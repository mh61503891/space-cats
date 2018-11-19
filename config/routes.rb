Rails.application.routes.draw do
  root to: 'contents#index'
  resources :contents
  resources :blobs, only: [:show] do
    collection do
      get :blank
    end
  end
  resources :keywords do
    collection do
      post :assign
    end
  end

  resources :pages do
    get :image
  end
  resources :images do
    get :image
  end
  match '/jobs' => DelayedJobWeb, anchor: false, via: [:get, :post]
end
