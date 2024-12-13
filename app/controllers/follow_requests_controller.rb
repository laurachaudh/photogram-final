class FollowRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @list_of_follow_requests = FollowRequest.order(created_at: :desc)
    render template: "follow_requests/index"
  end

  def show
    the_id = params[:id]
    @the_follow_request = FollowRequest.find_by(id: the_id)

    if @the_follow_request.nil?
      redirect_to root_path, alert: "Follow request not found."
    else
      render template: "follow_requests/show"
    end
  end

  def create
    recipient = User.find(params[:query_recipient_id])
    follow_request = current_user.sent_follow_requests.build(recipient: recipient)

    if follow_request.save
      # Automatically accept the request if the user is not private
      if !recipient.private
        follow_request.update(status: "accepted")
      end
      redirect_to user_profile_path(recipient.username), notice: "Follow request sent successfully."
    else
      redirect_to user_profile_path(recipient.username), alert: follow_request.errors.full_messages.to_sentence
    end
  end

  def update
    follow_request = FollowRequest.find(params[:id])
    if params[:status] == "accepted"
      follow_request.update(status: "accepted")
      redirect_to user_profile_path(current_user.username), notice: "Follow request accepted."
    elsif params[:status] == "rejected"
      follow_request.update(status: "rejected")
      redirect_to user_profile_path(current_user.username), notice: "Follow request rejected."
    else
      redirect_to user_profile_path(current_user.username), alert: "Invalid status."
    end
  end

  def destroy
    follow_request = FollowRequest.find(params[:id])
    follow_request.destroy

    redirect_to users_path, notice: "Unfollowed successfully."
  end

  def accept
    follow_request = FollowRequest.find(params[:id])
    if follow_request.update(status: "accepted")
      redirect_to user_profile_path(current_user.username), notice: "Follow request accepted."
    else
      redirect_to user_profile_path(current_user.username), alert: "Unable to accept follow request."
    end
  end

  def reject
    follow_request = FollowRequest.find(params[:id])
    if follow_request.update(status: "rejected")
      redirect_to user_profile_path(current_user.username), notice: "Follow request rejected."
    else
      redirect_to user_profile_path(current_user.username), alert: "Unable to reject follow request."
    end
  end
end
