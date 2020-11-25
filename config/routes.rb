Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'products#index'

  get '/orders/search', to: 'orders#search', as: "search_order"
  resources :orders, only: [:show, :edit, :update] do
    resources :order_items, only: [:update, :destroy]
  end

  #OmniAuth Login Route
  get "/auth/github", as: "github_login"
  #OmniAuth Github callback route
  get "auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
  delete "/logout", to: "merchants#logout", as: "logout"

  patch "/products/:id/toggle", to: "products#toggle_for_sale", as: "toggle_for_sale"
  resources :products do
    resources :order_items, only: [:create]
  end # only: [] or expect: []

  resources :merchants # only: [] or expect: []

  get "orders/:id/history", to: "orders#history", as: "order_history"

  patch "order_items/:id/ship", to: "order_items#ship_order_item", as: "ship_order_item"
  resources :order_items, except: [:create]

  resources :categories do
    resources :products, include: [:index, :show, :create]
  end

end
