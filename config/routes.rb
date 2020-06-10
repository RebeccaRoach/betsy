Rails.application.routes.draw do
  root to: 'homepages#index'
  
  resources :orderitems, only: [:edit, :destroy]
  patch 'orderitems/:id', to: 'orderitems#update'

  resources :orders, only: [:show, :edit]
  get '/cart', to: 'orders#cart', as: 'cart'
  patch '/orders/:id', to: 'orders#update'
end
