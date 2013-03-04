class RemoveParentIdFromStudent < ActiveRecord::Migration
  def up
    remove_column :students, :parent_id
  end

  def down
    add_column :students, :parent_id, :integer
  end
end
