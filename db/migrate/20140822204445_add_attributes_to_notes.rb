class AddAttributesToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :completed, :boolean
    add_column :notes, :action_date, :date
  end
end
