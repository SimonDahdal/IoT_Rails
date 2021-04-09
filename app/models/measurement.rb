class Measurement < ApplicationRecord
  validates :timestamp, presence: true
  validates :value, presence: true, numericality: true
  belongs_to :sensor

  validates_associated :sensor

  scope :index_by_sensor , -> (sensor_id){ where("sensor_id = ?", sensor_id)}

  scope :chart_data, -> (format) {
      if format.nil? or format == "1_week"
        where("timestamp > ?", 1.weeks.ago).pluck(:timestamp, :value)
      elsif format == "24_hours"
        where("timestamp > ?", 24.hours.ago).pluck(:timestamp, :value)
      elsif format == "1_month"
        where("timestamp > ?", 1.months.ago).pluck(:timestamp, :value)
      elsif format == "full"
        pluck(:timestamp, :value)
      else
        where("timestamp > ?", 1.weeks.ago).pluck(:timestamp, :value)
      end
  }
end
