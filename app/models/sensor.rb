class Sensor < ApplicationRecord

  validates :URI, presence: true, uniqueness: true
  validates :longitude, :latitude, numericality: true, presence: true

  belongs_to :user
  has_many :measurements, dependent: :destroy
  validates_associated :user

  reverse_geocoded_by :latitude, :longitude
  acts_as_notification_group printable_name: ->(sensor) { "sensor \"#{sensor.URI}\"" }
  acts_as_notifier printable_name: :URI

  scope :filter_by_sensor_types, -> (types) { where :sensor_type => types }
  scope :filter_by_position, -> (position, radius) {
    radius ||= 20
    near(position, radius, units: 'km')
  }
  scope :filter_by_public, -> { where("public = ?", true) }

  scope :all_sensor_last_measurements, -> {joins(:measurements).select("DISTINCT ON (sensor_id) sensors.*, value, timestamp").order("sensor_id", "timestamp DESC")}

  def position
    result = Geocoder.search([self.latitude,self.longitude]).first
    result.nil? ? "No address found" : result.address
  end
end
