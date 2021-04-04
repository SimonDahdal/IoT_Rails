Rails.application.routes.draw do
  resources :measurements
  resources :sensors
  devise_for :users
  get 'home/index'
  root 'home#index'


  get 'sensor/:sensor_id/measurements', to: 'measurements#index_measurements_sensor'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
