Rails.application.routes.draw do
  get "signup" => "users#new"
  resources :users
  resource :session

  root "events#index"

  resources :events do
    resources :registrations
  end
end
