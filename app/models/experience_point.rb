class ExperiencePoint < ActiveRecord::Base

  if Rails.env.development?
    #attr_accessible :created_at, :updated_at
  end

  validates_presence_of :experience_id, :student_id, :comment

  # validate :experience_id_exists

  belongs_to :user
  belongs_to :student
  belongs_to :experience
  belongs_to :grade, dependent: :destroy
  has_one :occupation, through: :experience
  belongs_to :badge_request
  has_one :attendance

  before_save :mark_negative
  after_save :update_student_xp
  after_update :update_student_xp
  after_destroy :update_student_xp, :cleanup

  def add_badge?(student)
    if experience.badge
      student.badges << badge
      true
    else
      false
    end
  end

  def badge
    if experience.badge
      experience.badge
    else
      nil
    end
  end

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

  def mark_negative
    if points == 0 && experience_id != 3
      self.negative = true
    end
  end

  private
  def cleanup
    unless self.badge_request.nil?
      self.badge_request.destroy
    end


    return unless self.attendance
    self.attendance.destroy unless self.attendance.destroyed?
  end
end
