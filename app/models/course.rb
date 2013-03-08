class Course < ActiveRecord::Base
  attr_accessible :course_name, :description
  has_many :offerings
  has_many :lessons
  has_many :grades
end
