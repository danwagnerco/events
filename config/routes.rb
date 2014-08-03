Rails.application.routes.draw do
  get "signup" => "users#new"
  resources :users

  root "events#index"

  resources :events do
    resources :registrations
  end
end
