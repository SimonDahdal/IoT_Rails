Rails.application.routes.draw do
  resources :sensors do
    resources :measurements
  end
  devise_for :users
  get 'home/index'
  root 'home#index'


  # get 'sensor/:sensor_id/measurements', to: 'measurements#index_measurements_sensor'
  get 'public_sensors', to: 'sensors#public_sensors_index'
  get 'pub_sensor/:sensor_id/measurements', to: 'measurements#index_measurements_public_sensor'

  post '/measurements.json', to: 'measurements#create_by_sensor'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
