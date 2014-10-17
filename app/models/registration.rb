class Registration < ActiveRecord::Base
  attr_accessible :admin_id, :attended_first_class, :attended_trial, :end_date, :hold_date, :offering_id, :start_date, :status, :student_id, :trial_date, :location_id, :hold_id, :switch_id, :switch, :restart_date

  validates_presence_of :offering_id, :location_id, :student_id

  belongs_to :student
  belongs_to :offering
  belongs_to :user
  belongs_to :location
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  has_one :course, through: :offering
  has_one :opportunity

  scope :active, lambda{where("status = ?", "1")}
  scope :future_adds, lambda{where("start_date > ? AND status = ?", Date.today, "Inactive")}
  scope :added_last_30, lambda{where("start_date < ? and start_date > ?", Date.today, 30.days.ago)}
  scope :dropped_last_30, lambda{where("end_date < ? and end_date > ?", Date.tomorrow, 30.days.ago)}
  scope :restarting, lambda{where("status = ? AND restart_date < ?", "Hold", 20.days.from_now)}

  STATUSES = ["New", "Active", "Hold", "Inactive"]

  def offering_name
    if offering
      course.course_name + " | " + offering.location.name + " | " + offering.day + " - " + offering.time.strftime("%I:%M %p")
    end
  end
end
