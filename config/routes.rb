Rails.application.routes.draw do
  resources :templates, only: [:index]
end
