class AddDefaultToFollowRequestsStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :follow_requests, :status, from: nil, to: "pending"
  end
end
