Rails.application.routes.draw do
  resources :sensors do
    resources :measurements
    collection do
      get :types
    end
  end
  devise_for :users
  notify_to :users, with_devise: :users, devise_default_routes: true
  get 'home/index'
  root 'home#index'



  # get 'sensor/:sensor_id/measurements', to: 'measurements#index_measurements_sensor'
  # get 'sensors/:sensor_id/measurements/:format', to: 'measurements#index'

  get 'public_sensors', to: 'sensors#public_sensors_index', as: :public_sensors
  get 'pub_sensor/:sensor_id/measurements', to: 'measurements#index_measurements_public_sensor', as: :public_sensor_measurements

  post 'sensors/:sensor_id/upload', to: 'sensors#upload'
  post 'sensors/:sensor_id/download', to: 'sensors#download'
  post 'sensors/:sensor_id/refresh_token', to: 'sensors#refresh_token'
  post '/measurements.json', to: 'measurements#create_by_sensor'

  get '/sensors_destroy_filter', to: 'sensors#destroy_filter_and_index'
  get '/public_sensors_destroy_filter', to: 'sensors#destroy_filter_and_public_index'

  #Tutti i Path sconosciuti verra reindirizzati verso il path route
  #get '*path' => redirect('/')

end
