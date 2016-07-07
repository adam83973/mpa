class Opportunity < ActiveRecord::Base
  #attr_accessible :admin_id, :attended_trial, :offering_id, :possible_restart_date, :registration_id,
                  # :status, :student_id, :trial_date, :appointment_date, :parent_name, :course_id,
                  # :location_id, :student_name, :date_won, :date_lost, :source, :title, :parent_phone,
                  # :parent_email, :interest_level, :other_source, :undecided_date, :user_id,
                  # :promotion_sent, :promotion_id, :missed_trial

  validates_presence_of :location_id

  has_paper_trail if Rails.env.development? || Rails.env.production?

  belongs_to :location
  belongs_to :student
  belongs_to :user
  belongs_to :course
  belongs_to :offering
  belongs_to :opportunity
  belongs_to :registration
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"

  has_many  :notes

  STATUSES = ["Interested", "Appointment Scheduled", "Appointment Missed", "Trial", "Undecided", "Waitlisted", "Possible Restart", "Won", "Lost"]

  SOURCES = ["Word Of Mouth", "Online Search", "Google Ad", "TV/Newspaper", "Direct Mail", "Event", "Unknown", "Other"]

  INTEREST_LEVELS = ["Low", "Medium", "High"]


  if Rails.env.production?
    data = Infusionsoft.data_find_by_field(:ContactGroup, 10, 0, :GroupCategoryId, 76, [:Id, :GroupName])
    PROMOTIONS = data.map { |hash| [hash["GroupName"], hash["Id"]] }
  elsif Rails.env.development?
    begin
      data = Infusionsoft.data_find_by_field(:ContactGroup, 10, 0, :GroupCategoryId, 14, [:Id, :GroupName])
      PROMOTIONS = data.map { |hash| [hash["GroupName"], hash["Id"]] }
    rescue SocketError => e
      PROMOTIONS = nil
    end
  end

  def add_missed_appointment_note
    parent = user
    note = parent.notes.build({content: "#{parent.full_name} missed their appointment. An email has been sent to ask to reschedule.", user_id: current_user.id, location_id: parent.location_id})
    note.save
  end

  def full_name
    if !(self.student) && ( self.student_name.empty? || self.student_name.nil? )
      "Parent: #{parent_name}"
    elsif self.student
      "Student: #{student_name}"
    else
      "Student: #{student.full_name}"
    end
  end

  def last_note
    notes.last
  end

  def offering_name
    if offering
      offering.offering_name
    end
  end

  #array of promotions with their associated tag/group ids. Pulls tags within the category "Undecided Tags"
  #[['Free Month', 1786], ['Two Weeks Free', 1788], ['No Deposit', 1790]]
  def promotions
    promotions = []
    if Rails.env.production?
      data = Infusionsoft.data_find_by_field(:ContactGroup, 10, 0, :GroupCategoryId, 76, [:Id, :GroupName])
    elsif Rails.env.development?
      data = Infusionsoft.data_find_by_field(:ContactGroup, 10, 0, :GroupCategoryId, 14, [:Id, :GroupName])
    end

    data = data.map { |hash| [hash["GroupName"], hash["Id"]] }
  end

  def status_actions
    parent = user
    if status == 8 #lost
      self.update_attribute :date_lost, Date.today
    elsif status == 4 #undecided
      self.update_attribute :undecided_date, Date.today
    elsif status == 2 #missed appointment
      puts "missed appointment"
      parent.missed_appointment
    end
  end

  def status_name
    if self.status
      STATUSES[self.status]
    else
      "No status selected."
    end
  end

  def update_status(id)
    id = id.to_i
    parent = user
    #["0, Interested", "1, Appointment Scheduled", "2, Appointment Missed", "3, Trial", "4, Undecided", "5, Waitlisted", "6, Possible Restart", "7, Won", "8, Lost"]
    update_column(:status, id.to_i)
    status_actions
  end
end
