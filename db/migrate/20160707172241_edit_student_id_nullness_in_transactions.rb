class EditStudentIdNullnessInTransactions < ActiveRecord::Migration
  def change
    change_column :transactions, :student_id, :integer, :null => true
  end
end
