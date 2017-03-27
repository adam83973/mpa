class AddCurrentOccupationIdToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :current_occupation_id, :integer
  end
end
