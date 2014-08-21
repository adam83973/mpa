class AddActiveSubscriptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :active_subscription, :boolean, default: false
  end
end
