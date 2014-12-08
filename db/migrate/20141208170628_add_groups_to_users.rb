class AddGroupsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group_1784, :boolean, default: false
    add_column :users, :group_1786, :boolean, default: false
    add_column :users, :group_1788, :boolean, default: false
    add_column :users, :group_1790, :boolean, default: false
  end
end
