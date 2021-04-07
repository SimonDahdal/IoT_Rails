class Measurement < ApplicationRecord
  validates :timestamp, presence: true
  validates :value, presence: true, numericality: true
  belongs_to :sensor

  validates_associated :sensor
end
