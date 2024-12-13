class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @list_of_users = User.order(created_at: :desc)
    render "users/index"
  end

  def show
    @the_user = User.find_by(username: params[:username])

    if @the_user.nil?
      redirect_to root_path, alert: "User not found."
    else
      # Count followers (received follow requests with status 'accepted')
      @followers_count = @the_user.received_follow_requests.where(status: "accepted").count

      # Count following (sent follow requests with status 'accepted')
      @following_count = @the_user.sent_follow_requests.where(status: "accepted").count

      # Pending follow requests (received follow requests with status 'pending')
      @pending_follow_requests = @the_user.received_follow_requests.where(status: "pending")
    end
  end

  def create
    the_user = User.new(user_params)

    if the_user.save
      redirect_to users_path, notice: "User created successfully."
    else
      redirect_to users_path, alert: the_user.errors.full_messages.to_sentence
    end
  end

  def update
    @the_user = User.find(params[:id])

    if @the_user.update(user_params)
      redirect_to user_profile_path(@the_user.username), notice: "User updated successfully."
    else
      redirect_to user_profile_path(@the_user.username), alert: @the_user.errors.full_messages.to_sentence
    end
  end

  def destroy
    @the_user = User.find(params[:id])
    @the_user.destroy
    redirect_to users_path, notice: "User deleted successfully."
  end

  private

  def user_params
    params.require(:user).permit(:username, :private, :email, :password, :password_confirmation)
  end
end
