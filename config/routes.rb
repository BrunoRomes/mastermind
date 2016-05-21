Rails.application.routes.draw do
  shallow do
    resources :games, only: [:index, :show, :create] do
      resources :players, only: [:create] do
        resources :guesses, only: [:create]
      end
    end
  end
end
