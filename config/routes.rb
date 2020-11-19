Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #OmniAuth Login Route
  get "/auth/github", as: "github_login"

  #OmniAuth Github callback route
  get "auth/:provider/callback", to: "merchant#create", as: "omniauth_callback"

  resources :products do
    resources :order_items, only: [:create]
  end # only: [] or expect: []

  resources :merchants # only: [] or expect: []

  resources :orders # only: [] or expect: []

  resources :order_items, except: [:create]
end
