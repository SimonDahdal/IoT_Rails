class AddPositionToSensors < ActiveRecord::Migration[6.1]
  def change
    add_column :sensors, :position, :string
  end
end
