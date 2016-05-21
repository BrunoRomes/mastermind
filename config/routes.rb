Rails.application.routes.draw do
  resources :templates, only: [:index]
  resources :games, only: [:create]
end
