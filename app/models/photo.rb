# == Schema Information
#
# Table name: photos
#
#  id             :bigint           not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string           not null
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :comments
  has_many :likes

  # Assuming you're using CarrierWave
  mount_uploader :image, ImageUploader

  validates :image, presence: true
end