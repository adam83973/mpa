class AddHoldStatusToStudents < ActiveRecord::Migration
  def change
    add_column :students, :hold_status, :integer
  end
end
