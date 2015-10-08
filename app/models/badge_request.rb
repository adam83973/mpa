class BadgeRequest < ActiveRecord::Base
  attr_accessible :approved, :badge_id, :parent_submission, :student_id, :user_id,
                  :date_approved, :write_up

  belongs_to :badge
  belongs_to :student
  belongs_to :user

  before_save :update_parent_submission

  def approve
    update_attributes approved: true, date_approved: Date.today

    if badge.experience_id
      experience =  Experience.find(badge.experience_id)
      ExperiencePoint.create!( student_id: student_id,
                               experience_id: badge.experience_id,
                               points: experience.points,
                               user_id: User.system_admin_id,
                               comment: "Congratulations on earning the #{badge.name} badge!" )
    end
  end

  def update_parent_submission
    if user.parent?
      toggle(:parent_submission) unless parent_submission
    end
  end
end
