class AddUserIdToSensors < ActiveRecord::Migration[6.1]
  def change
    add_column :sensors, :user_id, :integer
    add_index :sensors, :user_id
  end
end
