class ExperiencePoint < ActiveRecord::Base
  attr_accessible :experience_id, :points, :student_id, :experience_point

  belongs_to :student
  belongs_to :experience

  

end
