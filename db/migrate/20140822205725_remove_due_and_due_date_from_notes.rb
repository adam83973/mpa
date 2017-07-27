class RemoveDueAndDueDateFromNotes < ActiveRecord::Migration
  def up
    remove_column :notes, :due
    remove_column :notes, :due_date
  end

  def down
    add_column :notes, :due_date, :date
    add_column :notes, :due, :boolean
  end
end
