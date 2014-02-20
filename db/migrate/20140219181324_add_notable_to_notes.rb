class AddNotableToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :imageable_id, :integer
    add_column :notes, :imageable_type, :string
  end
end
