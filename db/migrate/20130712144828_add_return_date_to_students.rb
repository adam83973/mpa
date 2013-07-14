class AddReturnDateToStudents < ActiveRecord::Migration
  def change
    add_column :students, :return_date, :date
  end
end
