Rails.application.routes.draw do
  resources :planes
  root to: 'visitors#index'
end
