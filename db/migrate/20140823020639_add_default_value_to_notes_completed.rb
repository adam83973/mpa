class AddDefaultValueToNotesCompleted < ActiveRecord::Migration
  def change
    change_column :notes, :completed, :boolean, :default => false
  end
end
