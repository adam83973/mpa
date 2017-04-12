class Registration < ActiveRecord::Base
  #attr_accessible :admin_id, :attended_first_class, :attended_trial, :end_date, :hold_date, :offering_id, :start_date, :status, :student_id, :trial_date, :hold_id, :switch_id, :switch, :restart_date, :drop_reason, :payment_information_later

  attr_accessor :opportunity_id

  validates_presence_of :offering_id, :student_id

  has_paper_trail if Rails.env.development? || Rails.env.production?

  before_save :past_end_date

  belongs_to :student
  belongs_to :offering
  belongs_to :user
  belongs_to :holder, class_name: "Registration", foreign_key: "hold_id"
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  has_one :location, through: :offering
  has_one :course, through: :offering
  has_one :opportunity
  has_one :holding, class_name: "Registration", foreign_key: "hold_id"

  scope :active, lambda{where("registrations.status = ?", "1")}
  scope :future_adds, lambda{where("start_date > ?", Date.today).where("switch IS NULL OR switch = ?", false)}
  scope :added_last_30, lambda{where("start_date < ? and start_date > ?", Date.today, 30.days.ago)}
  scope :dropped_last_30, lambda{where("end_date < ? and end_date > ? AND switch_id IS NULL", Date.tomorrow, 30.days.ago)}
  scope :restarting, lambda{where("status = ? AND restart_date < ?", 2, 20.days.from_now)}

  STATUSES = ["New", "Active", "Hold", "Inactive"]
  DROP_REASONS = ["Moving", "Price", "Other Activity", "Dissatisfied", "Registered In Error", "Never Returned From Hold"]

  def active?
    status == 1
  end

  def self.active_registrations_by_locations_and_course(location_id, course_id)
    self.joins(:offering).joins(:course).where(status: 1, location_id: location_id).where("offerings.course_id = ?", course_id)
  end

  def restarting?
    status == 2 && restart_date < 20.days.from_now
  end

  def future_add?
    start_date > Date.today && (switch == nil || switch == false)
  end

  def course_name
    course.name if course
  end

  def offering_name
    if offering
      course.name + " | " + location.name + " | " + offering.day + " - " + offering.time.strftime("%I:%M %p")
    end
  end

  def offering_name_dashboard
      course.name + " \n " + offering.day[0..2] + " - " + offering.time.strftime("%I:%M %p")
  end

  def past_end_date
    if self.end_date && self.end_date <= Date.today
      self.status = 3
    end
  end

  def starts_today?
    start_date == Date.today
  end

  def start_has_passed?
    start_date < Date.today
  end

  def length_in_days
    (Date.today - start_date).to_i
  end

  #-----Registration Information Management-----

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      registration = find_by_id(row["id"]) || new
      registration.attributes = row.to_hash.slice(*accessible_attributes)
      registration.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |registration|
        csv << registration.attributes.values_at(*column_names)
      end
    end
  end
end
