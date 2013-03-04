class Course < ActiveRecord::Base
  attr_accessible :course_name, :description
  has_many :offerings
end
