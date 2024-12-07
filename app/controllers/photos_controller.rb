class PhotosController < ApplicationController

  before_action :authenticate_user!

  def index
    matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photos/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    render({ :template => "photos/show" })
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.comments_count = params.fetch("query_comments_count")
    the_photo.owner_id = params.fetch("query_owner_id")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.comments_count = params.fetch("query_comments_count")
    the_photo.owner_id = params.fetch("query_owner_id")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end

  def feed
    # Fetch all photos from users that the current user is following
    following_ids = current_user.following.pluck(:id)
    @feed_photos = Photo.where(owner_id: following_ids).order(created_at: :desc)

    render template: "photos/feed"
  end

  def discover
    # Fetch all photos liked by the users that the current user is following
    following_ids = current_user.following.pluck(:id)
    @discover_photos = Photo.joins(:likes).where(likes: { fan_id: following_ids }).distinct

    render template: "photos/discover"
  end
end
