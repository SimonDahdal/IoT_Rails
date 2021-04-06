class Sensor < ApplicationRecord
  belongs_to :user
  has_many :measurements, dependent: :destroy
end
