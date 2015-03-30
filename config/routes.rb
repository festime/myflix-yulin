Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'pages#front'
  get 'home', to: 'videos#index'
  get 'genre/:id', to: 'categories#show', as: :category # make category_path available

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search' # /videos/search
    end

    resources :reviews, only: [:create]
  end

  resources :users, only: [:create, :show]
  get 'register', to: 'users#new'

  get    'sign_in',  to: 'sessions#new'
  post   'sign_in',  to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy'

  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]

  put 'update_queue_items', to: 'queue_items#update_queue_items'

  get 'people',   to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  get 'forgot_password', to: 'reset_passwords#forgot_password'
  post 'confirm_password_reset', to: 'reset_passwords#confirm_password_reset'
  get 'reset_password/:token', to: 'reset_passwords#new', as: :reset_password
  post 'reset_password/:token', to: 'reset_passwords#create'
end
