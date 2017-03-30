class RemoveUnusedColumnsFromStudents < ActiveRecord::Migration[5.0]
  def change
    remove_column :students, :start_date
    remove_column :students, :hold_status
    remove_column :students, :start_hold_date
    remove_column :students, :restart_date
    remove_column :students, :return_date
    remove_column :students, :rank
  end
end
