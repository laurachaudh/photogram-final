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
    recipient_id = params[:query_recipient_id]
    recipient = User.find_by(id: recipient_id)
  
    if recipient.nil?
      redirect_to users_path, alert: "User not found."
      return
    end
  
    follow_request = current_user.sent_follow_requests.build(recipient_id: recipient.id, status: "pending")
  
    if follow_request.save
      # Automatically accept the request for public users
      if recipient.private == false
        follow_request.update(status: "accepted")
      end
      redirect_to users_path, notice: "Follow request sent successfully."
    else
      redirect_to users_path, alert: follow_request.errors.full_messages.to_sentence
    end
  end
  

  def update
    follow_request = FollowRequest.find_by(id: params[:id])

    if follow_request.nil?
      redirect_to root_path, alert: "Follow request not found."
      return
    end

    case params[:status]
    when "accepted"
      if follow_request.update(status: "accepted")
        redirect_to user_profile_path(follow_request.sender.username), notice: "Follow request accepted."
      else
        redirect_to user_profile_path(follow_request.sender.username), alert: "Unable to accept follow request."
      end
    when "rejected"
      if follow_request.update(status: "rejected")
        redirect_to user_profile_path(follow_request.sender.username), notice: "Follow request rejected."
      else
        redirect_to user_profile_path(follow_request.sender.username), alert: "Unable to reject follow request."
      end
    else
      redirect_to root_path, alert: "Invalid status."
    end
  end

  def destroy
    follow_request = FollowRequest.find_by(id: params[:id])

    if follow_request.nil?
      redirect_to root_path, alert: "Follow request not found."
      return
    end

    follow_request.destroy
    redirect_to users_path, notice: "Follow request canceled."
  end

  def accept
    follow_request = FollowRequest.find_by(id: params[:id])

    if follow_request.nil?
      redirect_to root_path, alert: "Follow request not found."
      return
    end

    if follow_request.update(status: "accepted")
      redirect_to user_profile_path(follow_request.sender.username), notice: "Follow request accepted."
    else
      redirect_to user_profile_path(follow_request.sender.username), alert: "Unable to accept follow request."
    end
  end

  def reject
    follow_request = FollowRequest.find_by(id: params[:id])

    if follow_request.nil?
      redirect_to root_path, alert: "Follow request not found."
      return
    end

    if follow_request.destroy
      redirect_to user_profile_path(follow_request.sender.username), notice: "Follow request rejected."
    else
      redirect_to user_profile_path(follow_request.sender.username), alert: "Unable to reject follow request."
    end
  end
end
