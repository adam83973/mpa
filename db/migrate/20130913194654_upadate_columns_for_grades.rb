class UpadateColumnsForGrades < ActiveRecord::Migration
  def up
  	add_column :grades, :comment, :text
  	add_column :grades, :user_id, :integer
  	add_column :grades, :grade_type, :string
  	remove_column :grades, :course_id
	remove_column :grades, :assessment
  end

  def down
  	remove_column :grades, :comment
  	remove_column :grades, :user_id
  	remove_column :grades, :grade_type
  	add_column :grades, :course_id, :integer
	add_column :grades, :assessment, :boolean
  end
end
