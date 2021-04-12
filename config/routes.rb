Rails.application.routes.draw do
  resources :sensors do
    resources :measurements
    collection do
      get :types
    end
  end
  devise_for :users
  get 'home/index'
  root 'home#index'



  # get 'sensor/:sensor_id/measurements', to: 'measurements#index_measurements_sensor'
  get 'sensors/:sensor_id/measurements/:format', to: 'measurements#index'

  get 'public_sensors', to: 'sensors#public_sensors_index'
  get 'pub_sensor/:sensor_id/measurements', to: 'measurements#index_measurements_public_sensor'

  post 'sensors/:sensor_id/upload', to: 'sensors#upload'
  post 'sensors/:sensor_id/download', to: 'sensors#download'


  post '/measurements.json', to: 'measurements#create_by_sensor'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
