class AddWriteUpToBadgeRequests < ActiveRecord::Migration
  def change
    add_column :badge_requests, :write_up, :text
  end
end
