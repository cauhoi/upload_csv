Rails.application.routes.draw do
  get 'users/bulk_upload'
  post 'users/remove_all'
  post 'users/upload'
  resources :users
  root 'users#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
