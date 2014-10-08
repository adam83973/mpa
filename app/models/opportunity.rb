class Opportunity < ActiveRecord::Base
  attr_accessible :admin_id, :attended_trial, :offering_id, :possible_restart_date, :registration_id,
                  :status, :student_id, :trial_date, :appointment_date, :parent_name, :course_id, :location_id,
                  :student_name, :date_won, :date_lost, :source, :title, :parent_phone, :parent_email

  belongs_to :location
  belongs_to :student
  belongs_to :course
  belongs_to :offering
  belongs_to :opportunity
  belongs_to :registration
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"

  has_many  :notes, as: :notable

  STATUSES = ["Interested", "Appointment Scheduled", "Appointment Missed", "Trial", "Undecided", "Waitlisted", "Possible Restart", "Won", "Lost"]

  SOURCES = ["Word Of Mouth", "Online Search", "Google Ad", "TV/Newspaper", "Direct Mail", "Event"]

  def full_name
    if self.student
      self.student.full_name
    else
      self.student_name
    end
  end

  def update_status(id)
    #["0, Interested", "1, Appointment Scheduled", "2, Appointment Missed", "3, Trial", "4, Undecided", "5, Waitlisted", "6, Possible Restart", "7, Won", "8, Lost"]
    update_column(:status, id.to_i)
  end

  def status_name
    if self.status
      STATUSES[self.status]
    else
      "No status selected."
    end
  end
end
