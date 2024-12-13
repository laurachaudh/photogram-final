class LikesController < ApplicationController
  before_action :authenticate_user!

  # Liked photos index
  def index
    @liked_photos = current_user.likes.includes(:photo).map(&:photo)
    render template: "likes/index"
  end

  # Create a like
  def create
    photo = Photo.find(params[:photo_id])
    like = current_user.likes.new(photo: photo)

    if like.save
      photo.increment!(:likes_count)
      redirect_to photo_path(photo), notice: "Like created successfully."
    else
      redirect_to photo_path(photo), alert: like.errors.full_messages.to_sentence
    end
  end

  # Destroy a like
  def destroy
    like = current_user.likes.find(params[:id])
    photo = like.photo

    if like.destroy
      photo.decrement!(:likes_count)
      redirect_to photo_path(photo), notice: "Like deleted successfully."
    else
      redirect_to photo_path(photo), alert: "Unable to unlike the photo."
    end
  end

  def liked_photos
    @the_user = User.find_by(username: params[:username])
    if @the_user.nil?
      redirect_to root_path, alert: "User not found."
      return
    end
  
    @liked_photos = @the_user.likes.includes(:photo).map(&:photo)
    @followers_count = @the_user.followers.count
    @following_count = @the_user.following.count
    @pending_follow_requests = @the_user.received_follow_requests.pending if current_user == @the_user
  
    render template: "likes/liked_photos"
  end
end
