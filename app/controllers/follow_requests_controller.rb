class FollowRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @list_of_follow_requests = FollowRequest.order(created_at: :desc)
    render template: "follow_requests/index"
  end

  def show
    the_id = params.fetch("path_id")
    @the_follow_request = FollowRequest.find(the_id)
    render template: "follow_requests/show"
  end

  def create
    recipient = User.find(params[:query_recipient_id])
    status = recipient.private ? "pending" : "accepted"

    the_follow_request = FollowRequest.new(
      sender_id: current_user.id,
      recipient_id: recipient.id,
      status: status
    )

    if the_follow_request.save
      notice_message = recipient.private ? "Follow request sent for approval." : "You are now following #{recipient.username}."
      redirect_to users_path, notice: notice_message
    else
      redirect_to users_path, alert: the_follow_request.errors.full_messages.to_sentence
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.find(the_id)

    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.save
      redirect_to users_path, notice: "Follow request updated successfully."
    else
      redirect_to users_path, alert: the_follow_request.errors.full_messages.to_sentence
    end
  end

  def destroy
    recipient_id = params[:path_id] # Using recipient_id for better clarity
    follow_request = current_user.sent_follow_requests.find_by(recipient_id: recipient_id)

    if follow_request
      follow_request.destroy
      redirect_to users_path, notice: "Follow request canceled."
    else
      redirect_to users_path, alert: "Follow request not found."
    end
  end

  def accept
    follow_request = FollowRequest.find(params[:id])

    if follow_request.update(status: "accepted")
      redirect_to user_profile_path(follow_request.sender.username), notice: "Follow request accepted."
    else
      redirect_to user_profile_path(follow_request.sender.username), alert: "Unable to accept follow request."
    end
  end

  def reject
    follow_request = FollowRequest.find(params[:id])

    if follow_request.destroy
      redirect_to user_profile_path(follow_request.sender.username), notice: "Follow request rejected."
    else
      redirect_to user_profile_path(follow_request.sender.username), alert: "Unable to reject follow request."
    end
  end
end
