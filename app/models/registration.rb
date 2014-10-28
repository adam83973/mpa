class Registration < ActiveRecord::Base
  attr_accessible :admin_id, :attended_first_class, :attended_trial, :end_date, :hold_date, :offering_id, :start_date, :status, :student_id, :trial_date, :hold_id, :switch_id, :switch, :restart_date

  attr_accessor :opportunity_id

  validates_presence_of :offering_id, :student_id

  before_save :past_end_date

  belongs_to :student
  belongs_to :offering
  belongs_to :user
  belongs_to :holder, class_name: "Registration", foreign_key: "hold_id"
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  has_one :course, through: :offering
  has_one :opportunity
  has_one :holding, class_name: "Registration", foreign_key: "hold_id"

  scope :active, lambda{where("status = ?", "1")}
  scope :future_adds, lambda{where("start_date > ?", Date.today).where("switch IS NULL OR switch = ?", false)}
  scope :added_last_30, lambda{where("start_date < ? and start_date > ?", Date.today, 30.days.ago)}
  scope :dropped_last_30, lambda{where("end_date < ? and end_date > ? AND switch_id IS NULL", Date.tomorrow, 30.days.ago)}
  scope :restarting, lambda{where("status = ? AND restart_date < ?", 2, 20.days.from_now)}

  STATUSES = ["New", "Active", "Hold", "Inactive"]

  def offering_name
    if offering
      course.course_name + " | " + offering.location.name + " | " + offering.day + " - " + offering.time.strftime("%I:%M %p")
    end
  end

  def past_end_date
    if self.end_date && self.end_date <= Date.today
      self.status = 3
    end
  end
end
