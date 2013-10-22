class RemoveTypeFromResources < ActiveRecord::Migration
  def up
    remove_column :resources, :type
  end

  def down
    add_column :resources, :type, :string
  end
end
