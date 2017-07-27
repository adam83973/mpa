class AddSubscriptionIdToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :subscription_id, :integer
  end
end
