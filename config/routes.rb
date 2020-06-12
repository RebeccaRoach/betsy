Rails.application.routes.draw do
  root to: 'pages#index'
  resources :pages, only: :index

  resources :products
  resources :merchants

  resources :orderitems, only: [:edit, :destroy]
  patch 'orderitems/:id', to: 'orderitems#update'
  patch 'orderitems/:id/mark_shipped', to: 'orderitems#markshipped', as: 'mark_shipped'

  resources :orders, only: [:show, :edit, :update]
  get '/orders/:id/cart', to: 'orders#cart', as: 'cart'
  # need custom route for place order?

  resources :reviews, only: [:new, :create]
  resources :categories, only: [:new, :create, :show, :index]

  resources :merchants
  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get '/orders/:id/merchant_order', to: 'orders#merchant_order', as: 'merchant_order'
end
