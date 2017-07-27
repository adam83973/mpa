class ExperiencePoint < ActiveRecord::Base

  validates_presence_of :experience_id, :student_id, :comment

  belongs_to :user
  belongs_to :student
  belongs_to :experience
  belongs_to :grade, dependent: :destroy
  has_one :occupation, through: :experience
  belongs_to :badge_request
  has_one :attendance

  before_save :toggle_negative
  after_create :update_student_xp_level_credits_on_create
  after_update :update_student_xp_level_credits_on_update
  after_destroy :update_student_xp_level_credits_on_destroy, :cleanup

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

  private

    def cleanup
      unless self.badge_request.nil?
        self.badge_request.destroy
      end
      return unless self.attendance
      self.attendance.destroy unless self.attendance.destroyed?
    end

    def toggle_negative
      if points == 0 && !(experience.name =~ /\bAttendance\b/)
        self.negative = true
      else
        self.negative = false
        true
      end
    end

    def update_student_xp_level_credits_on_create
      # Calculate credits earned.
      credits = (student.experience_point_total + points)/100 - ((student.experience_point_total)/100)
      # Add credits earned.
      student.add_remove_credits(credits)
      puts "*****************Added Credits!*****************"
      puts "*****************Credits :: #{credits}*****************"
      # Updating current occupation xp, occupation levels and total xp
      student.update_occupation_experience_points_and_level(points)
    end

    def update_student_xp_level_credits_on_update
      previous_points = points_was
      if points >= previous_points
        # Calculate credits earned.
        credits = (student.experience_point_total + (points - previous_points))/100 - ((student.experience_point_total)/100)
        # Add credits earned.
        student.add_remove_credits(credits)
        puts "Points were: #{points_was}"
        puts "*****************Added Credits!*****************"
        puts "*****************Credits :: #{credits}*****************"
        # Updating current occupation xp, occupation levels and total xp
        student.update_occupation_experience_points_and_level(points - previous_points)
      end
    end

    def update_student_xp_level_credits_on_destroy
      puts "*****************Credit Level Xp Update!*****************"
      # Calculate credits to be subtracted.
      credits = (student.experience_point_total - points)/100 - ((student.experience_point_total)/100)
      # Remove credits lost
      student.add_remove_credits(credits)
      # Updating current occupation xp, occupation levels and total xp
      student.update_occupation_experience_points_and_level(-points)
    end
end
