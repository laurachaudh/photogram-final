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
      redirect_to photo_path(photo), notice: "Successfully unliked the photo."
    else
      redirect_to photo_path(photo), alert: "Unable to unlike the photo."
    end
  end
end
