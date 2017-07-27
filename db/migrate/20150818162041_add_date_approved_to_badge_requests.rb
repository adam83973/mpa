class AddDateApprovedToBadgeRequests < ActiveRecord::Migration
  def change
    add_column :badge_requests, :date_approved, :date
  end
end
