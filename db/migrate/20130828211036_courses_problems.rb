class CoursesProblems < ActiveRecord::Migration
  def change
    create_table :courses_problems, :id => false do |t|
    	t.integer :problem_id
    	t.integer :course_id
    end
    add_index :courses_problems, [:problem_id, :course_id]
  end
end