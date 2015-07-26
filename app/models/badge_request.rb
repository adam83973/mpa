class BadgeRequest < ActiveRecord::Base
  attr_accessible :approved, :badge_id, :parent_submission, :student_id, :user_id

  belongs_to :student
  belongs_to :user
  belongs_to :badge
end
