class RemoveFieldsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :group_1784
    remove_column :users, :group_1786
    remove_column :users, :group_1788
    remove_column :users, :group_1790
    remove_column :users, :group_1784_start
    remove_column :users, :group_1786_start
    remove_column :users, :group_1788_start
    remove_column :users, :group_1790_start
  end

  def down
    add_column :users, :group_1790_start, :date
    add_column :users, :group_1788_start, :date
    add_column :users, :group_1786_start, :date
    add_column :users, :group_1784_start, :date
    add_column :users, :group_1790, :boolean
    add_column :users, :group_1788, :boolean
    add_column :users, :group_1786, :boolean
    add_column :users, :group_1784, :boolean
  end
end
