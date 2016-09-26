class User < ActiveRecord::Base
  include Encryption

  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  validates_presence_of :first_name, :last_name, :role, :location_id

  attr_encrypted :ssn, key: :encryption_key
  attr_encrypted :bank_account, key: :encryption_key
  attr_encrypted :routing_number, key: :encryption_key

  after_save :update_status

  attr_accessor :current_password, :opportunity_id, :send_password_link

  has_many :assignments
  has_many :badge_requests
  has_many :help_session_records
  has_many :messages
  has_many :emails, class_name: "Ahoy::Message"
  has_many :notings, class_name: "Note", foreign_key: "user_id"
  belongs_to :location
  has_many :students, :through => :offerings
  has_many :students
  has_many :registrations, :through => :students
  has_many :active_registrations, -> {where( registrations: { status: 0..2 })},
           through: :students,
           source: :registrations

  has_many :opportunities
  has_many :leads
  has_many :issues
  has_many :appointments, dependent: :destroy
  has_many :experience_points
  has_many  :notes, as: :notable, dependent: :destroy
  has_and_belongs_to_many :offerings
  has_many :enrollment_changings, class_name: "EnrollmentChangeRequest", foreign_key: "user_id"
  has_many :enrollment_change_requests, class_name: "EnrollmentChangeRequest", foreign_key: "admin_id"
  has_many :transactions

  scope :active, lambda{where("active = ?", true)}
  scope :employees, lambda{where("role = ? OR role = ? OR role = ? OR role = ? OR role = ? OR role = ?", 'Teacher', 'Teaching Assistant', 'Robotics Instructor', 'Programming Instructor', 'Chess Instructor', 'Admin').where(active: true).order('last_name asc')}
  scope :teachers, lambda{where("role = ?", 'Teacher').where(active: true).order('last_name asc')}
  scope :teaching_assistants, lambda{where("role = ?", 'Teaching Assistant').where(active: true).order('last_name asc')}

  ROLES = ["Admin", "Teacher", "Teaching Assistant", "Parent", "Robotics Instructor", "Programming Instructor", "Chess Instructor"]

  def full_name
      first_name + " " + last_name
  end

  def full_address?
    !address.blank? && !city.blank? && !state.blank? && !zip.blank?
  end

  def self.search(search)
    if search
      if search.split.count == 2
        where('lower(first_name) LIKE ? AND lower(last_name) LIKE ?', "%#{search.split.first.downcase}%", "%#{search.split.last.downcase}%")
      else
       where('lower(first_name) LIKE ? OR lower(last_name) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%")
     end
    end
  end

  def teacher?
    ["Teacher", "Teaching Assistant", "Robotics Instructor", "Programming Instructor", "Chess Instructor"].include?(self.role)
  end

  def employee?
    if self.role
      ["Admin", "Teacher", "Teaching Assistant", "Robotics Instructor", "Programming Instructor", "Chess Instructor"].include?(self.role)
    end
  end

  def active_employees
    where("role != ? AND active = ?", "Parent", true)
  end

  #parent methods
  def parent?
    ["Parent"].include?(self.role)
  end

  def active_parents
    where("role = ? AND active = ?", "Parent", true)
  end

  def active_students?
    active_registrations.any?
  end

  def missed_appointment
    Rails.env.production? ? tag_id = 1838 : tag_id = 109
    unless appointment_rescheduled?
      if Infusionsoft.contact_add_to_group(infusion_id, tag_id) #adds tag: "missed appt."
        #this stops multiple reschedule requests from being submitted.
        update_attribute :appointment_rescheduled, true
        note = notes.build({user_id: system_admin_id, content: "#{full_name} missed their appointment. An email was sent on #{Date.today.strftime("%D")}. Please contact to reschedule if no response by #{(Date.today + 3.days).strftime("%D")}.", action_date: Date.today + 3.days, location_id: location.id })
        note.save
      end
    end
  end

  def deactivate
    if active
      update_attributes active: false
    end

    if students
      students.each do |student|
        student.update_attributes status: "Inactive"
        student.update_attributes end_date: Date.today
      end
    end
  end

  # Infusionsoft administration
  def active_subscription?
    if parent?
      Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => infusion_id, :Status => "Active"}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] ).any?
    end
  end

  def subscriptions_count
    if parent?
      Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => infusion_id, :Status => "Active"}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] ).count
    end
  end

  def last_payment_infusion
    if self.infusion_id && self.role == 'Parent' && !self.last_payment.nil?
      JSON::parse(last_payment)
    else
      return []
    end
  end

  def infusionsoft_tags
    # {"ContactGroup"=>"Newsletter and Marketing", "GroupId"=>91}
    if infusion_id
      tags = Infusionsoft.data_query('ContactGroupAssign', 20, 0, {:ContactId => infusion_id}, [:GroupId, :ContactGroup, :DateCreated])
      tags.each do |tag|
        tag['DateCreated'] = DateTime.new(tag['DateCreated'].year, tag['DateCreated'].month, tag['DateCreated'].day, tag['DateCreated'].hour, +5)
      end
      tags = tags.sort_by{ |tag| tag['DateCreated'] }
    else
      []
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user = find_by_id(row["id"]) || new
      user.attributes = row.to_hash.slice(*accessible_attributes)
      user.save!(:validate => false)
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end

  def self.parent_email_to_csv
    CSV.generate do |csv|
      all.each do |parent|
        email = Array.new
        email << "#{parent.full_name} <#{parent.email}>,"
        csv << email
      end
    end
  end

  def self.parent_email_only_to_csv
    CSV.generate do |csv|
      all.each do |parent|
        email = Array.new
        email << parent.email
        csv << email
      end
    end
  end

  def system_admin_id
    if Rails.env.production?
      757
    elsif Rails.env.development?
      460
    end
  end

  def self.system_admin_id
    if Rails.env.production?
      757
    elsif Rails.env.development?
      460
    end
  end

  def update_status
    if self.parent? && self.infusion_id
      if Rails.env.production?
        begin
          self.active ? Infusionsoft.contact_add_to_group(infusion_id, 1694) : Infusionsoft.contact_remove_from_group(infusion_id, 1694)
        rescue => error
          puts infusion_id
          puts $!.message #
        end
      elsif Rails.env.development?
        puts "Status Updated"
        # Add or remove active tag in infusionsoft development application
        self.active ? Infusionsoft.contact_add_to_group(infusion_id, 113) : Infusionsoft.contact_remove_from_group(infusion_id, 113)
      end
    end
  end
end
