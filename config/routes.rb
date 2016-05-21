Rails.application.routes.draw do
  resources :games, only: [:index, :create] do
  end
end
