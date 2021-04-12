class Sensor < ApplicationRecord

  validates :URI, presence: true, uniqueness: true
  validates :longitude, :latitude, numericality: true, presence: true

  belongs_to :user
  has_many :measurements, dependent: :destroy

  validates_associated :user

  scope :all_public , -> { where("public = ?", true)}
end
