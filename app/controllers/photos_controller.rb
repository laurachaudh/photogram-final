class PhotosController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :update, :destroy, :feed, :discover]

  def index
    @public_photos = Photo.joins(:owner).where(users: { private: false }).order(created_at: :desc)
    render "photos/index"
  end

  def show
    @the_photo = Photo.find_by(id: params[:id])
  
    if @the_photo.nil?
      redirect_to photos_path, alert: "Photo not found."
      return
    end
  
    render template: "photos/show"
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

  def update
    the_photo = Photo.find_by(id: params[:id])

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
    the_photo = Photo.find_by(id: params[:id])

    if the_photo.nil?
      redirect_to photos_path, alert: "Photo not found."
      return
    end

    the_photo.destroy
    redirect_to photos_path, notice: "Photo deleted successfully."
  end

  def feed
    @user = User.find_by(username: params[:username])

    if @user.nil?
      redirect_to root_path, alert: "User not found."
    else
      following_ids = @user.following.pluck(:id)
      @feed_photos = Photo.where(owner_id: following_ids).order(created_at: :desc)
    end

    render template: "photos/feed"
  end

  def discover
    following_ids = current_user.following.pluck(:id)

    @discover_photos = if following_ids.any?
                         Photo.joins(:likes).where(likes: { fan_id: following_ids }).distinct
                       else
                         Photo.none
                       end

    render template: "photos/discover"
  end

  private

  def photo_params
    params.require(:photo).permit(:caption, :image)
  end
end
