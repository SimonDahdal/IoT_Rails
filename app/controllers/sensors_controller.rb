class SensorsController < ApplicationController
  before_action :authenticate_user!, except: [:public_sensors_index,:destroy_filter_and_index]
  before_action :set_sensor, only: %i[ show edit update destroy]
  before_action :clear_params, only: [:index,:public_sensors_index]
  # GET /sensors or /sensors.json

  def index
    @sensors = current_user.sensors
    @types = @sensors.order(:sensor_type).distinct.pluck(:sensor_type)

    filtering_params(params).each do |key, value|
      session[key] = value if value.present?
    end

    @sensors = @sensors.filter_by_sensor_types(session[:sensor_types]) if session[:sensor_types].present?
    @sensors = @sensors.filter_by_position(session[:position],session[:radius]) if session[:position].present?
    @sensors = @sensors.all_sensor_last_measurements

    @checked = session[:sensor_types].present? ? session[:sensor_types].compact.join(', ') : nil
    @position = session[:position]
    @radius = session[:radius]
    @commit = params[:commit].split[2] if params[:commit].present?

    @sensors.all_sensor_last_measurements
  end

  def destroy_filter_and_index
    session[:sensor_types]=nil
    session[:position]=nil
    session[:radius]=nil
    redirect_to sensors_path
  end

  def public_sensors_index
    @sensors = Sensor.filter_by_public
  end

  # GET /sensors/1 or /sensors/1.json
  def show
    @last=@sensor.measurements.last_measure
    #per visualizzare avviso in caso di down
    @alarm = false
    if @sensor.notifica_down
    then
      @recent = @sensor.measurements.recent(@sensor.tdown.hours.ago)
      if @recent.blank?
      then
        @alarm = true
      end
    end
    @measurements=@sensor.measurements.order_most_recent
  end

  # GET /sensors/new
  def new
    @sensor = Sensor.new
  end

  # GET /sensors/1/edit
  def edit
  end

  # POST /sensors or /sensors.json
  def create
    @sensor = Sensor.new(sensor_params)

    respond_to do |format|
      if @sensor.save
        format.html { redirect_to @sensor, notice: 'Sensor was successfully created.' }
        format.json { render :show, status: :created, location: @sensor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sensors/1 or /sensors/1.json
  def update
    respond_to do |format|
      if @sensor.update(sensor_params)
        format.html { redirect_to @sensor, notice: 'Sensor was successfully updated.' }
        format.json { render :show, status: :ok, location: @sensor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensors/1 or /sensors/1.json
  def destroy
    @sensor.destroy
    respond_to do |format|
      format.html { redirect_to sensors_url, notice: 'Sensor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    uploaded_file = params[:firmware_file]
    File.open(Rails.root.join('app','assets', 'uploads', "#{params[:sensor_id]}_#{uploaded_file.original_filename}"), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    sensor = Sensor.find(params[:sensor_id])
    sensor.firmware = uploaded_file.original_filename
    if sensor.save!
      redirect_to sensor_path(params[:sensor_id]), notice: 'Firmware was successfully updated.'
    else
      redirect_to sensor_path(params[:sensor_id]), notice: 'Firmware wasn\'t successfully updated.'
    end
  end

  def download
    send_file("#{Rails.root}/app/assets/uploads/#{params[:sensor_id]}_#{params[:firmware]}")
  end

  def types
    @types = current_user.sensor.order(:sensor_type).distinct.pluck(:sensor_type)
  end

  private

  def set_sensor
    @sensor = Sensor.find(params[:id])
  end

  def filtering_params(parameters)
    parameters.slice(:sensor_types, :position, :radius)
  end

  # Only allow a list of trusted parameters through.
  def sensor_params
    params.require(:sensor).permit(:URI, :sensor_type, :public, :latitude, :longitude, :firmware, :notifica_down, :tdown, :measure_unit, :user_id)
  end

  def clear_params
    params.compact_blank!
  end
end
