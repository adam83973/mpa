class Grade < ActiveRecord::Base
  attr_accessible :assessment, :course_id, :lesson_id, :score, :student_id
end
