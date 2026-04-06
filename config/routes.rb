Rails.application.routes.draw do
  devise_for :users

  resources :accounts do
    resources :transactions, only: [:new, :create]
  end

  root "accounts#index"
end