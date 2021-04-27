class Measurement < ApplicationRecord
  validates :timestamp, presence: true
  validates :value, presence: true, numericality: true
  belongs_to :sensor

  validates_associated :sensor

  acts_as_notifiable :users,
                     targets: -> (measurement, key){ [measurement.sensor.user] },
                     group: :sensor, notifier: :sensor,
                     notifiable_path: :sensor_notifiable_path,
                     tracked: { only: [:create], key: 'measurement.create', notify_later: false },
                     printable_name: ->(measurement) { "measurement \"#{measurement.value}\"" },
                     dependent_notifications: :update_group

  def sensor_notifiable_path
    sensor_path(sensor)
  end

  scope :index_by_sensor , -> (sensor_id){ where("sensor_id = ?", sensor_id)}

  scope :recent, ->(time){ where("timestamp > ?", time)}

  scope :last_measure, ->{ order("timestamp DESC").first}

  scope :order_most_recent, ->{ order("timestamp DESC")}

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
