class AddDefaultToCurrentOccupationIdOnStudents < ActiveRecord::Migration[5.0]
  def change
    change_column :students, :current_occupation_id, :integer, :default => 1
  end
end
