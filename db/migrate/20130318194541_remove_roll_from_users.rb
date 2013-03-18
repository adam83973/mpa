class RemoveRollFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :roll
  end

  def down
    add_column :users, :roll, :string
  end
end
