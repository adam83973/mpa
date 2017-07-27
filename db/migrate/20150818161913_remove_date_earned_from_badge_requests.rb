class RemoveDateEarnedFromBadgeRequests < ActiveRecord::Migration
  def up
    remove_column :badge_requests, :date_earned
  end

  def down
    add_column :badge_requests, :date_earned, :date
  end
end
