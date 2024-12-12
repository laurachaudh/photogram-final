Rails.application.routes.draw do
  # Devise routes for users
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  
  devise_for :users

  # Root route
  root to: "users#index"

  # User-related routes
  get "/users", to: "users#index", as: "users"
  get "/users/:username", to: "users#show", as: :user_profile
  get "/users/:username/likes", to: "likes#index", as: :user_likes
  get "/users/:username/feed", to: "photos#feed", as: :user_feed

  # Routes for the FollowRequest resource
  resources :follow_requests, only: [:create, :destroy] do
    member do
      patch :accept
      delete :reject
    end
  end

  # Routes for the Photo resource
  resources :photos, only: [:index, :create, :show, :update, :destroy] do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create, :index, :show, :destroy], shallow: true
  end

  # Discover route
  get "/discover", to: "photos#discover", as: :discover
end

