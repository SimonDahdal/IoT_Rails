class AddAuthTokenToSensor < ActiveRecord::Migration[6.1]
  def change
    add_column :sensors, :auth_token, :string
    add_index :sensors, :auth_token, unique: true
  end
end
