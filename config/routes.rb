Rails.application.routes.draw do
  root to: 'contents#index'
  resources :contents
  match '/jobs' => DelayedJobWeb, anchor: false, via: [:get, :post]
end
