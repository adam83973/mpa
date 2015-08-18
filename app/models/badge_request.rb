class BadgeRequest < ActiveRecord::Base
  attr_accessible :approved, :badge_id, :parent_submission, :student_id, :user_id,
                  :date_approved

  belongs_to :badge
  belongs_to :student
  belongs_to :user

  def approve
    update_attributes approved: true, date_approved: Date.today
  end
end
