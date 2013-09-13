class UpdateColumnsForLessons < ActiveRecord::Migration
  def up
  	remove_column :lessons, :course_id
  	add_column :lessons, :standard_id, :integer
  end

  def down
  	add_column :lessons, :course_id, :integer
  	remove_column :lessons, :standard_id
  end
end
