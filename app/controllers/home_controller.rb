class HomeController < ApplicationController
  def index
    #se utente loggato verifico se notificare i sensori con impostata la notifica down
    if user_signed_in?
      then
      @notifications = current_user.unopened_notification_index_with_attributes
      @sensors = current_user.sensors
      @sensors1 = current_user.sensors.all_sensor_last_measurements
      message = "sensori down: \n"
      alert=false
      @sensors.each do |sensor|
        measure = @sensors1.select { |sensor1| sensor1.id == sensor.id }.first
        if sensor.notifica_down
        then
          if !measure.nil? then
            if measure.timestamp.blank? || measure.timestamp < sensor.tdown.hours.ago then
              alert=true
              message.concat(sensor.URI)
              message.concat(" \n")
            end
          else
            alert=true
            message.concat(sensor.URI)
            message.concat(" \n")
          end
        end
      end
      @alert= alert
      flash.alert=message
    end
  end
end
