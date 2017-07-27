class RemoveImageableIdFromNotes < ActiveRecord::Migration
  def up
    remove_column :notes, :imageable_id
    remove_column :notes, :imageable_type
  end

  def down
    add_column :notes, :imageable_type, :string
    add_column :notes, :imageable_id, :integer
  end
end
