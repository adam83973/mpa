class RemoveActiveFromStudents < ActiveRecord::Migration
  def up
    remove_column :students, :active
  end

  def down
    add_column :students, :active, :boolean
  end
end
