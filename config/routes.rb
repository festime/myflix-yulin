Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'videos#index'
  get 'genre/:id', to: 'categories#show'

  resources :videos, only: [:show]
end
