class Grade < ActiveRecord::Base
  #attr_accessible :assessment, :user_id, :lesson_id, :score, :student_id, :comment, :grade_type, :experience_point_attributes

  belongs_to :lesson
  belongs_to :student
  has_one :experience_point

  accepts_nested_attributes_for :experience_point
  #belongs_to :course
end
