class ExperiencePoint < ActiveRecord::Base
  attr_accessible :experience_id, :points, :student_id, :experience_point, :user_id, :comment

  validates_presence_of :experience_id, :student_id

  validate :experience_id_exists, :comment_exists

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

  def experience_id_exists
    begin
      Experience.find(self.experience_id)
    rescue ActiveRecord::RecordNotFound
      errors.add(:experience_id, "Select a valid Achievement.")
      false
    end
  end

  def comment_exists
    if experience_id == 2
    else
      if self.comment == ""
        errors.add(:comment, "You must add a comment.")
        false
      end
    end
  end

  def update_student_xp
   	student.calculate_xp
   end
end
