Rails.application.routes.draw do
  # Devise routes for users
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  
  devise_for :users

  get "/users", to: "users#index", as: "users"

  # Root route
  root to: "users#index"

  # User profile route
  get "/users/:username", to: "users#show", as: :user_profile

  # Routes for the Follow request resource
  resources :follow_requests, only: [:create, :destroy] do  
    member do
      patch :accept
      delete :reject
    end
  end

  # Routes for the Like resource
  post "/insert_like", to: "likes#create"
  get "/likes", to: "likes#index"
  get "/likes/:path_id", to: "likes#show"
  post "/modify_like/:path_id", to: "likes#update"
  get "/delete_like/:path_id", to: "likes#destroy"

  # Routes for the Comment resource
  post "/insert_comment", to: "comments#create"
  get "/comments", to: "comments#index"
  get "/comments/:path_id", to: "comments#show"
  post "/modify_comment/:path_id", to: "comments#update"
  get "/delete_comment/:path_id", to: "comments#destroy"

  # Routes for the Photo resource
  post "/insert_photo", to: "photos#create"
  get "/photos", to: "photos#index"
  get "/photos/:path_id", to: "photos#show"
  post "/modify_photo/:path_id", to: "photos#update"
  get "/delete_photo/:path_id", to: "photos#destroy"
  get "/feed", to: "photos#feed", as: :feed

  get "/discover", to: "photos#discover", as: :discover

end
