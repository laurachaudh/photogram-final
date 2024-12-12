class AddForeignKeysToFollowRequests < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :follow_requests, :users, column: :sender_id
    add_foreign_key :follow_requests, :users, column: :recipient_id
  end
end

