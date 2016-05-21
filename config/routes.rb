Rails.application.routes.draw do
  shallow do
    resources :games, only: [:index, :create] do
      resources :players, only: [:create] do
        resources :guesses, only: [:create]
      end
    end
  end
end
