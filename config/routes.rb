Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'pages#front'
  get 'home', to: 'videos#index'
  get 'genre/:id', to: 'categories#show'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search' # /videos/search
    end

    resources :reviews, only: [:create]
  end

  resources :users, only: [:create]
  get 'register', to: 'users#new'

  get    'sign_in',  to: 'sessions#new'
  post   'sign_in',  to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy'
end
