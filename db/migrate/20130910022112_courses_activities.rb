class CoursesActivities < ActiveRecord::Migration
  def change
  	create_table :activities_courses, :id => false do |t|
  		t.integer :activity_id
  		t.integer :course_id
  	end
  end
end
