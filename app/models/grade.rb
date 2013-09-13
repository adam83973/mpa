class Grade < ActiveRecord::Base
  attr_accessible :assessment, :course_id, :lesson_id, :score, :student_id
  
  belongs_to :lesson
  belongs_to :student
  belongs_to :course
end
