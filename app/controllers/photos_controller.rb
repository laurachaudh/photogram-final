class PhotosController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @public_photos = Photo.joins(:owner).where(users: { private: false }).order(created_at: :desc)
    render "photos/index"
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where(id: the_id)
    @the_photo = matching_photos.first

    if @the_photo.present?
      render template: "photos/show"
    else
      redirect_to photos_path, alert: "Photo not found."
    end
  end

  def create
    the_photo = Photo.new(photo_params)
    the_photo.owner_id = current_user.id
  
    if the_photo.save
      redirect_to photos_path, notice: "Photo created successfully."
    else
      Rails.logger.debug("Photo Save Errors: #{the_photo.errors.full_messages}")
      redirect_to photos_path, alert: the_photo.errors.full_messages.to_sentence
    end
  end

  private

def photo_params
  params.require(:photo).permit(:caption, :image)
end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.find_by(id: the_id)

    if the_photo.nil?
      redirect_to photos_path, alert: "Photo not found."
      return
    end

    if the_photo.update(photo_params)
      redirect_to photo_path(the_photo), notice: "Photo updated successfully."
    else
      redirect_to photo_path(the_photo), alert: the_photo.errors.full_messages.to_sentence
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.find_by(id: the_id)

    if the_photo.nil?
      redirect_to photos_path, alert: "Photo not found."
      return
    end

    the_photo.destroy
    redirect_to photos_path, notice: "Photo deleted successfully."
  end

  def feed
    # Fetch all photos from users that the current user is following
    authenticate_user!
    following_ids = current_user.following.pluck(:id)
    @feed_photos = Photo.where(owner_id: following_ids).order(created_at: :desc)

    render template: "photos/feed"
  end

  def discover
    # Fetch all photos liked by the users that the current user is following
    authenticate_user!
    following_ids = current_user.following.pluck(:id)
    @discover_photos = Photo.joins(:likes).where(likes: { fan_id: following_ids }).distinct

    render template: "photos/discover"
  end

  private

  def photo_params
    params.require(:photo).permit(:caption, :image)
  end
end
