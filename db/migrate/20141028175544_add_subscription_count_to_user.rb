class AddSubscriptionCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscription_count, :integer
  end
end
