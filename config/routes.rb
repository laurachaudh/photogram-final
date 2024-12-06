Rails.application.routes.draw do
  # Devise routes for users
  devise_for :users

  # Root route
  root to: "photos#index"

  # Routes for the Follow request resource
  post("/insert_follow_request", { :controller => "follow_requests", :action => "create" })
  get("/follow_requests", { :controller => "follow_requests", :action => "index" })
  get("/follow_requests/:path_id", { :controller => "follow_requests", :action => "show" })
  post("/modify_follow_request/:path_id", { :controller => "follow_requests", :action => "update" })
  get("/delete_follow_request/:path_id", { :controller => "follow_requests", :action => "destroy" })

  # Routes for the Like resource
  post("/insert_like", { :controller => "likes", :action => "create" })
  get("/likes", { :controller => "likes", :action => "index" })
  get("/likes/:path_id", { :controller => "likes", :action => "show" })
  post("/modify_like/:path_id", { :controller => "likes", :action => "update" })
  get("/delete_like/:path_id", { :controller => "likes", :action => "destroy" })

  # Routes for the Comment resource
  post("/insert_comment", { :controller => "comments", :action => "create" })
  get("/comments", { :controller => "comments", :action => "index" })
  get("/comments/:path_id", { :controller => "comments", :action => "show" })
  post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })
  get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })

  # Routes for the Photo resource
  post("/insert_photo", { :controller => "photos", :action => "create" })
  get("/photos", { :controller => "photos", :action => "index" })
  get("/photos/:path_id", { :controller => "photos", :action => "show" })
  post("/modify_photo/:path_id", { :controller => "photos", :action => "update" })
  get("/delete_photo/:path_id", { :controller => "photos", :action => "destroy" })

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
