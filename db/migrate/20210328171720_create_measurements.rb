class CreateMeasurements < ActiveRecord::Migration[6.1]
  def change
    create_table :measurements do |t|
      t.timestamp :timestamp
      t.float :value

      t.timestamps
    end
  end
end
