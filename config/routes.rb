Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'homepages#index'

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
  resources :orders # only: [] or expect: []

  resources :order_items, except: [:create]
end
