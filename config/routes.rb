Rails.application.routes.draw do
  root to: 'uploads#new'
  resources :uploads, only: [:new, :create]

  post 'column_headers', :to => 'uploads#column_headers'
end
