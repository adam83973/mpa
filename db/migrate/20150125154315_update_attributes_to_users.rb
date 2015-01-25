class UpdateAttributesToUsers < ActiveRecord::Migration
  def change
    change_column :users, :subscription_count, :integer, :default => 0
  end
end
