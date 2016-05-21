Rails.application.routes.draw do
  shallow do
    get 'games/availables', to: 'games#availables'
    resources :games, only: [:show, :create] do

      resources :players, only: [:create] do
        resources :guesses, only: [:create]
      end
    end
  end
  
end
