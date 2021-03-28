class CreateSensors < ActiveRecord::Migration[6.1]
  def change
    create_table :sensors do |t|
      t.string :URI
      t.string :sensor_type
      t.boolean :public
      t.float :latitude
      t.float :longitude
      t.string :firmware
      t.boolean :notifica_down
      t.integer :tdown
      t.string :measure_unit

      t.timestamps
    end
    add_index :sensors, :URI, unique: true
  end
end
