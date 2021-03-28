json.extract! sensor, :id, :URI, :sensor_type, :public, :latitude, :longitude, :firmware, :notifica_down, :tdown, :measure_unit, :created_at, :updated_at
json.url sensor_url(sensor, format: :json)
