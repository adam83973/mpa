class AddDateEarnedToBadgeRequest < ActiveRecord::Migration
  def change
    add_column :badge_requests, :date_earned, :date
  end
end
