class SensorsController < ApplicationController
  before_action :authenticate_user!, except: [:public_sensors_index]
  before_action :set_sensor, only: %i[ show edit update destroy ]

  # GET /sensors or /sensors.json
  def index
    @sensors = current_user.sensors
  end

  def public_sensors_index
    #@sensors = Sensor.where('public = true')
    @sensors=Sensor.all_public
  end

  # GET /sensors/1 or /sensors/1.json
  def show
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
    File.open(Rails.root.join('public', 'uploads', "#{params[:sensor_id]}_#{uploaded_file.original_filename}"), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    sensor=Sensor.find(params[:sensor_id])
    sensor.firmware=uploaded_file.original_filename
    if sensor.save!
      redirect_to sensor_path(params[:sensor_id]), notice: 'Firmware was successfully updated.'
    else
      redirect_to sensor_path(params[:sensor_id]), notice: 'Firmware wasn\'t successfully updated.'
    end
  end
  def download
    send_file("#{Rails.root}/public/uploads/#{params[:sensor_id]}_#{params[:firmware]}")
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sensor
    @sensor = Sensor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sensor_params
    params.require(:sensor).permit(:URI, :sensor_type, :public, :latitude, :longitude, :firmware, :notifica_down, :tdown, :measure_unit, :user_id)
  end
end
