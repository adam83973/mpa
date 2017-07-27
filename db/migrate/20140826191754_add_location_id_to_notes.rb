class AddLocationIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :location_id, :integer
  end
end
