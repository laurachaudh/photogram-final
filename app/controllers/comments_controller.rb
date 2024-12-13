class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    # Ensure the photo exists
    @photo = Photo.find(params[:photo_id])
    comment = @photo.comments.new(comment_params)
    comment.author_id = current_user.id

    if comment.save
      @photo.increment!(:comments_count)
      redirect_to photo_path(@photo), notice: "Comment added successfully."
    else
      redirect_to photo_path(@photo), alert: "Unable to add comment: #{comment.errors.full_messages.to_sentence}."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :photo_id)
  end
end
