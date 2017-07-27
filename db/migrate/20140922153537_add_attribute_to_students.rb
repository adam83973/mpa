class AddAttributeToStudents < ActiveRecord::Migration
  def change
    add_column :students, :attended_frist_class, :boolean, default: false
  end
end
