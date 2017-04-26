class RemoveAttendedFirstClassFromStudents < ActiveRecord::Migration[5.0]
  def change
    remove_column :students, :attended_first_class
  end
end
