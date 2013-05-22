class RemoveUserIdFromOffering < ActiveRecord::Migration
  def up
    remove_column :offerings, :user_id
  end

  def down
    add_column :offerings, :user_id, :integer
  end
end
