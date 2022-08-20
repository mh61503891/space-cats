Rails.application.routes.draw do
  root to: "search#index"
  namespace :search do
    get :index
    post :index
  end
  resources :notes
  namespace :contents do
    resource :import
  end
  resources :contents do
    patch :fetch_metadata
    resources :notes, controller: "contents/notes"
  end
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
