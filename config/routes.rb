Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  resources :users do
    resources :posts do
      resources :comments

      member do
        post 'like', to: 'posts#like', as: :like
        delete 'unlike', to: 'posts#unlike', as: :unlike
      end
    end
  end
end
