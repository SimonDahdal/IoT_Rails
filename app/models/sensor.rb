class Sensor < ApplicationRecord

  validates :URI, presence: true, uniqueness: true
  validates :longitude, :latitude, numericality: true, presence: true

  belongs_to :user
  has_many :measurements, dependent: :destroy
  validates_associated :user

  reverse_geocoded_by :latitude, :longitude
  #after_validation :reverse_geocode if (:latitude_changed? or :longitude_changed?)

  scope :filter_by_sensor_types, -> (types) { where :sensor_type => types }
  scope :filter_by_position, -> (position, radius) {
    radius ||= 20
    near(position, radius, units: 'km')
  }
  scope :filter_by_public, -> { where("public = ?", true) }

  def position
    result = Geocoder.search([self.latitude,self.longitude]).first
    result.nil? ? "No address found" : result.address
  end
end
