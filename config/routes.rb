Rails.application.routes.draw do
  resources :games, only: [:index, :create] do
    resources :players, only: [:create]
  end
end
