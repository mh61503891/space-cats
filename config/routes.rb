Rails.application.routes.draw do

  root to: 'contents#index'
  resources :contents

end
