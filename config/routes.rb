Rails.application.routes.draw do
  root to: 'pages#index'
  resources :pages, only: [:index]

  resources :products, except: [:destroy] do
    resources :orderitems, only: [:create]
    patch :retired, on: :member #products/1/retired
  end

  resources :orderitems, only: [:edit, :update, :destroy]
  patch 'orderitems/:id/mark_shipped', to: 'orderitems#mark_shipped', as: 'mark_shipped'

  resources :orders, only: [:new, :show, :edit, :update, :cancel]
  # # below for checkout success confirmation page
  get '/orders/:id/cart/success', to: 'orders#success', as: 'success'
  get '/orders/:id/cart', to: 'orders#cart', as: 'cart'

  resources :merchants

  post "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
  get '/orders/:id/merchant_order', to: 'orders#merchant_order', as: 'merchant_order'
  resources :reviews, only: [:new, :create]
  resources :categories, only: [:new, :create]
end
