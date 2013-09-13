class Grade < ActiveRecord::Base
  attr_accessible :assessment, :user_id, :lesson_id, :score, :student_id, :comment, :grade_type
  
  belongs_to :lesson
  belongs_to :student
  #belongs_to :course
end
