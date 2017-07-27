class AddCompletedByToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :completed_by, :integer
  end
end
