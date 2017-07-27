class ChangeCourseNameOnCourses < ActiveRecord::Migration[5.0]
  def change
    rename_column :courses, :course_name, :name
  end
end
