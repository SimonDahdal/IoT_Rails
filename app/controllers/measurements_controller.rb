class MeasurementsController < ApplicationController
  before_action :authenticate_user!, except: [:index_measurements_public_sensor]
  before_action :set_measurement, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:create]
  # GET /measurements or /measurements.json
  def index
    @measurements = Measurement.joins(:sensor).where("sensors.public = 'true'")
  end

  def index_measurements_sensor
    @sensor = Sensor.find_by_id(params[:sensor_id])
    @measurements = Measurement.joins(:sensor).where("sensors.id = #{params[:sensor_id]}")
  end

  def index_measurements_public_sensor
    @sensor = Sensor.find_by_id(params[:sensor_id])
    if @sensor.public == true
      @measurements = Measurement.joins(:sensor).where("sensors.id = #{params[:sensor_id]}")
    else
      @measurements = nil
    end
  end

  # GET /measurements/1 or /measurements/1.json
  def show
  end


  # GET /measurements/new
  def new
    @measurement = Measurement.new
  end

  # GET /measurements/1/edit
  def edit
  end

  # POST /measurements or /measurements.json
  def create
    sid = Sensor.where(URI: measurement_params[:sensor_uri]).pluck(:id).first
    mp1 = measurement_params.merge(sensor_id: sid)
    mp2 = mp1.extract!(:sensor_uri)
    @measurement = Measurement.new(mp1)


    respond_to do |format|
      if @measurement.save
        format.html { redirect_to @measurement, notice: "Measurement was successfully created." }
        format.json { render :show, status: :created, location: @measurement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /measurements/1 or /measurements/1.json
  def update
    mp1 = measurement_params
    mp2 = mp1.extract!(:sensor_uri)
    respond_to do |format|
      if @measurement.update(mp1)
        format.html { redirect_to @measurement, notice: "Measurement was successfully updated." }
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
      format.html { redirect_to measurements_url, notice: "Measurement was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement
      @measurement = Measurement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def measurement_params
      params.require(:measurement).permit(:timestamp, :value, :sensor_uri, :sensor_id)
    end
end
