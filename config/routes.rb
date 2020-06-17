Rails.application.routes.draw do
  root to: 'pages#index'
  resources :pages, only: :index

  resources :products, except: [:destroy] do
    resources :orderitems, only: [:create]
  end

  resources :orderitems, only: [:update, :destroy]
  patch 'orderitems/:id/mark_shipped', to: 'orderitems#mark_shipped', as: 'mark_shipped'
  patch '/orderitems/:id', to: 'orderitems#update'

  resources :orders, only: [:new, :show, :edit, :update, :cancel]
  get '/orders/:id/cart', to: 'orders#cart', as: 'cart'
  get '/orders/:id/cart/success', to: 'orders#submit', as: 'confirm_submit'

  resources :merchants

  post "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
  get '/orders/:id/merchant_order', to: 'orders#merchant_order', as: 'merchant_order'

  resources :reviews, only: [:new, :create]
  resources :categories, only: [:new, :create, :show, :index]
end
