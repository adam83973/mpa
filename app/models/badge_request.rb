class BadgeRequest < ActiveRecord::Base
  #attr_accessible :approved, :badge_id, :parent_submission, :student_id, :user_id,
                  # :date_approved, :write_up

if Rails.env.development?
  #attr_accessible :created_at, :updated_at
end

  belongs_to :badge
  belongs_to :student
  belongs_to :user
  has_many   :modules, class_name: 'BadgeModule', source: :badge_modules
  has_one    :experience_point

  before_save :update_parent_submission

  def approve
    update_attributes approved: true, date_approved: Date.today

    if badge.experience_id
      experience =  Experience.find(badge.experience_id)
      student = Student.find student_id
      ExperiencePoint.create!( student_id: student_id,
                               experience_id: badge.experience_id,
                               points: experience.points,
                               user_id: User.system_admin_id,
                               comment: "Congratulations on earning the #{badge.name} badge!" )
    end
  end

  def update_parent_submission
    if user && user.parent?
      toggle(:parent_submission) unless parent_submission
    end
  end
end
