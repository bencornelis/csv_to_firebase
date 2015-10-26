Rails.application.routes.draw do
  root to: 'uploads#new'
  resources :uploads, only: [:new, :create]

  post 'file_metadata', :to => 'uploads#file_metadata'
end
