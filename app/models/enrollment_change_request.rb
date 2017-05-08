class EnrollmentChangeRequest < ActiveRecord::Base

  belongs_to :parent, class_name: "User", foreign_key: "user_id"
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  belongs_to :student

  REASONS = ["Financial Constraints", "Long Term Vacation/Travel", "Extra curricular activities take priority over MPA enrichment classes.", "Other"]

  STATUSES = ["Pending", "Completed", "Cancelled"]

  TYPE = ["Hold", "Termination"]
end
