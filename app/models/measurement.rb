class Measurement < ApplicationRecord
  validates :timestamp, presence: true
  validates :value, presence: true, numericality: true
  belongs_to :sensor

  validates_associated :sensor

  scope :index_by_sensor , -> (sensor_id){ where("sensor_id = ?", sensor_id)}
end
