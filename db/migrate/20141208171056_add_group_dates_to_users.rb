class AddGroupDatesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group_1784_start, :date
    add_column :users, :group_1786_start, :date
    add_column :users, :group_1788_start, :date
    add_column :users, :group_1790_start, :date
  end
end
