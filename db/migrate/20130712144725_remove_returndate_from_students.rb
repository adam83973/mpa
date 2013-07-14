class RemoveReturndateFromStudents < ActiveRecord::Migration
  def up
    remove_column :students, :returndate
  end

  def down
    add_column :students, :returndate, :date
  end
end
