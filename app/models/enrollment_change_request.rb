class EnrollmentChangeRequest < ActiveRecord::Base
  attr_accessible :admin_id, :end_date, :hold_return_date, :hold_start_date,
                  :other_reason, :reason_id, :restart_billing_authorization,
                  :status, :student_id, :user_id, :customer_experience, :possible_return_date

  belongs_to :parent, class_name: "User", foreign_key: "user_id"
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  belongs_to :student

  REASONS = ["Financial Constraints", "Long Term Vacation/Travel", "Extra curricular activities take priority over MPA enrichment classes.", "Other"]

  STATUSES = ["Pending", "Completed", "Cancelled"]

  TYPE = ["Hold", "Termination"]
end
