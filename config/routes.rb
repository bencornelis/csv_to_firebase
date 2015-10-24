Rails.application.routes.draw do
  root to: 'uploads#new'
  resources :uploads, only: [:new, :create]
end
