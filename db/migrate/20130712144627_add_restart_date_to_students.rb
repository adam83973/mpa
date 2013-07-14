class AddRestartDateToStudents < ActiveRecord::Migration
  def change
    add_column :students, :restart_date, :date
  end
end
