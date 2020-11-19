Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :products # only: [] or expect: []

  resources :merchants # only: [] or expect: []

  resources :orders # only: [] or expect: []

  resources :order_items
end
