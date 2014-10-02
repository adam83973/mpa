class Opportunity < ActiveRecord::Base
  attr_accessible :admin_id, :attended_trial, :offering_id, :possible_restart_date, :registration_id,
                  :status, :student_id, :trial_date, :appointment_date, :parent_name, :course_id, :location_id,
                  :student_name, :date_won, :date_lost, :source, :title

  belongs_to :location
  belongs_to :student
  belongs_to :course
  belongs_to :offering
  belongs_to :opportunity
  belongs_to :registration
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"

  STATUSES = ["Interested", "Appointment Scheduled", "Appointment Missed", "Trial", "Undecided", "Waitlisted", "Possible Restart", "Won", "Lost"]

  SOURCES = ["Word Of Mouth", "Online Search", "Google Ad", "TV/Newspaper", "Direct Mail", "Event"]
end
