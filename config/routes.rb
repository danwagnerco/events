Rails.application.routes.draw do

  resources :categories

  resources :users
  get "signup" => "users#new"
  
  resource :session
  get "signin" => "sessions#new"

  root "events#index"

  resources :events do
    resources :registrations
    resources :likes
  end
end
