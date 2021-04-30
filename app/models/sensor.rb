class Sensor < ApplicationRecord

  validates :URI, presence: true, uniqueness: true
  validates :longitude, :latitude, numericality: true, presence: true

  belongs_to :user
  has_many :measurements, dependent: :destroy
  validates_associated :user

  reverse_geocoded_by :latitude, :longitude, :address => :position
  after_validation :reverse_geocode, if: ->(obj){ (obj.latitude.present? and obj.latitude_changed?) or (obj.longitude.present? and obj.longitude_changed?) }

  acts_as_notification_group printable_name: ->(sensor) { "sensor \"#{sensor.URI}\"" }
  acts_as_notifier printable_name: :URI

  scope :filter_by_sensor_types, -> (types) { where :sensor_type => types }
  scope :filter_by_position, -> (position, radius) {
    radius ||= 20
    near(position, radius, units: 'km')
  }
  scope :filter_by_public, -> { where("public = ?", true) }

  scope :all_sensor_last_measurements, -> {joins(:measurements).select("DISTINCT ON (sensor_id) sensors.*, value, timestamp").order("sensor_id", "timestamp DESC")}
  #escape delle virgolette, che sono necessarie a postgres per evitare conversione automatica URI in minuscolo
  scope :filter_by_uri, -> (pattern) { where("\"URI\" LIKE ?", '%' + pattern + '%')}
end
