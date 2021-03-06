class Opportunity < ActiveRecord::Base

  validates_presence_of :location_id, :status

  has_paper_trail if Rails.env.development? || Rails.env.production?

  belongs_to :location
  belongs_to :student
  belongs_to :user
  belongs_to :course
  belongs_to :offering
  belongs_to :registration
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"

  has_many  :notes

  scope :active, -> { where("status < ?", 7) }

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

  def mark_as_won
    self.update_attributes status: 7, date_won: Date.today
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

  def statuses_select_without_win
    # For select options. Includes index and value
  end

  def self.report_data
    data = []
    opportunities = Opportunity.active
    Location.all.each do |location|
      location_stats = {}
      location_stats['location'] = location.name
      location_stats['opportunities'] = {}
      STATUSES.each_with_index do |status, i|
        if i < 7
          location_stats['opportunities'][status.downcase.gsub(' ', '_')] = opportunities.where(status: i, location_id: location.id).count
        end
      end
      data << location_stats
    end
    data
  end

  def self.aging_data
    data = []
    opportunities = Opportunity.where("created_at > ?", Date.today - 60.days)

    STATUSES.each_with_index do |status, i|
      status_data = {}
      status_data['name'] = status.downcase.gsub(' ', '_')
      status_data['opportunities'] = []

      opportunities.where(status: i).each do |opp|
        opportunity = {id: opp.id, location_id: opp.location_id, age: (Date.today - opp.created_at.to_date).to_i}
        status_data['opportunities'] << opportunity
      end

      data << status_data
    end

    data
  end
end
