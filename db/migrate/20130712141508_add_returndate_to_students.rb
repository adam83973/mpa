class AddReturndateToStudents < ActiveRecord::Migration
  def change
    add_column :students, :returndate, :date
  end
end
