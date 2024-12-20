# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer
#  private                :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :photos, foreign_key: :owner_id, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_many :likes, foreign_key: :fan_id, dependent: :destroy
  has_many :liked_photos, through: :likes, source: :photo

  # Follow requests
  has_many :sent_follow_requests, class_name: "FollowRequest", foreign_key: :sender_id, dependent: :destroy
  has_many :received_follow_requests, class_name: "FollowRequest", foreign_key: :recipient_id, dependent: :destroy

  # Followers and following relationships
  has_many :followers, -> { where(follow_requests: { status: "accepted" }) }, through: :received_follow_requests, source: :sender
  has_many :following, -> { where(follow_requests: { status: "accepted" }) }, through: :sent_follow_requests, source: :recipient

  validates :username, presence: true, uniqueness: true

  # Helper methods

  # Check if the user is following another user
  def following?(other_user)
    following.exists?(id: other_user.id)
  end

  # Check if there is a pending follow request for another user
  def pending_follow_request?(other_user)
    sent_follow_requests.exists?(recipient_id: other_user.id, status: "pending")
  end

  # Check if the user is followed by another user
  def followed_by?(other_user)
    followers.exists?(id: other_user.id)
  end

  # Check if there is a pending follow request from another user
  def pending_follow_request_from?(other_user)
    received_follow_requests.exists?(sender_id: other_user.id, status: "pending")
  end
end
