class MeasurementsController < ApplicationController
  before_action :authenticate_user!, except: [:index_measurements_public_sensor, :create_by_sensor]
  before_action :get_sensor, except: [:create_by_sensor]
  before_action :set_measurement, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:create_by_sensor]
  # GET /measurements or /measurements.json
  #
  # def index
  #  @measurements = Measurement.joins(:sensor).where("sensors.public = 'true'")
  # end

  def index
    @measurements = @sensor.measurements
    @data = @measurements.chart_data(params[:format])
    if params[:format].nil? or params[:format] == "1_week"
      @label = "1 Week Ago"
    elsif params[:format] == "24_hours"
      @label = "24 Hours Ago"
    elsif params[:format] == "1_month"
        @label = "1 Month Ago"
    elsif params[:format] == "full"
        @label = "Full Period"
    else
      @label = "Not valid Period -> 7 days ago"
    end
  end

  def index_measurements_public_sensor
    if @sensor.public == true
      @measurements = @sensor.measurements
      if params[:format].nil? or params[:format] == "1_week"
        @data = @measurements.where("timestamp > ?", 1.weeks.ago).pluck(:timestamp, :value)
        @label = "1 Week Ago"

      elsif params[:format] == "24_hours"
        @data = @measurements.where("timestamp > ?", 24.hours.ago).pluck(:timestamp, :value)
        @label = "24 Hours Ago"

      elsif params[:format] == "1_month"
        @data = @measurements.where("timestamp > ?", 1.months.ago).pluck(:timestamp, :value)
        @label = "1 Month Ago"

      elsif params[:format] == "full"
        @data = @measurements.pluck(:timestamp, :value)
        @label = "Full Period"
      else
        @data = @measurements.where("timestamp > ?", 1.weeks.ago).pluck(:timestamp, :value)
        @label = "Not valid Period -> 7 days ago"
      end
    else
      @measurements = nil
    end
  end

  # GET /measurements/1 or /measurements/1.json
  def show
  end


  # GET /measurements/new
  def new
    @measurement = @sensor.measurements.build
  end

  # GET /measurements/1/edit
  def edit
  end

  # POST /measurements or /measurements.json
  def create
    @measurement = @sensor.measurements.build(measurement_params)
    create_respond
  end

  def create_by_sensor
    #sid = Sensor.where(URI: measurement_params[:sensor_uri]).pluck(:id).first
    #mp1 = measurement_params.merge(sensor_id: sid)
    #mp2 = mp1.extract!(:sensor_uri)
    #@measurement = Measurement.new(mp1)
    @sensor = Sensor.where(URI: measurement_params[:sensor_uri]).first
    @measurement = @sensor.measurements.build(measurement_params.except(:sensor_uri))
    create_respond
  end

  # PATCH/PUT /measurements/1 or /measurements/1.json
  def update
    mp1 = measurement_params
    mp2 = mp1.extract!(:sensor_uri)
    respond_to do |format|
     if @measurement.update(mp1)
        format.html { redirect_to sensor_measurements_path(@sensor), notice: "Measurement was successfully updated." }
        format.json { render :show, status: :ok, location: @measurement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /measurements/1 or /measurements/1.json
  def destroy
    @measurement.destroy
    respond_to do |format|
      format.html { redirect_to sensor_measurements_path(@sensor), notice: "Measurement was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement
      @measurement = @sensor.measurements.find(params[:id])
    end

    def get_sensor
      @sensor = Sensor.find(params[:sensor_id])
    end

    # Only allow a list of trusted parameters through.
    def measurement_params
      params.require(:measurement).permit(:timestamp, :value, :sensor_uri, :sensor_id)
    end

  def create_respond
    respond_to do |format|
      if @measurement.save
        format.html { redirect_to sensor_measurements_path(@sensor), notice: "Measurement was successfully created." }
        format.json { render :show, status: :created, location: @measurement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end
end
