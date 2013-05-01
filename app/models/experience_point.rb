class ExperiencePoint < ActiveRecord::Base
  attr_accessible :experience_id, :points, :student_id, :experience_point, :user_id, :comment

  belongs_to :user
  belongs_to :student
  belongs_to :experience

  after_save :update_student_xp
  after_update :update_student_xp
  after_destroy :update_student_xp

  def student_name
  	student.try(:full_name)
  end

  def student_name=(name)
  	self.student = Student.find_by_name(name) if name.present?
  end

  def update_student_xp
   	student.calculate_xp
   end
end
