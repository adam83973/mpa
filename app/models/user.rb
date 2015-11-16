class User < ActiveRecord::Base

  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  validates_presence_of :first_name, :last_name, :role

  attr_accessible :email, :password, :current_password, :password_confirmation, :remember_me,
                  :offering_ids, :active, :address, :admin, :first_name, :has_key, :last_name, :location_id, :passion,:phone, :role, :shirt_size, :infusion_id, :last_payment, :active_subscription, :send_password_link, :opportunity_id, :subscription_count, :balance_due, :check_appointments_id, :default_location, :confirmation_opt_out,:billing_note, :hide_badge_banner, :first_email_reminder

  attr_accessor :current_password, :opportunity_id, :send_password_link

  has_many :badge_requests
  has_many :messages
  has_many :notings, class_name: "Note", foreign_key: "user_id"
  belongs_to :location
  has_many :students, :through => :offerings
  has_many :students
  has_many :registrations, :through => :students
  has_many :active_registrations, :through => :students, class_name: 'Registration', source: :registrations, conditions: "registrations.status IN (0, 1, 2) or registrations.start_date IN ('2015-10-09', '2015-10-14')"

  has_many :opportunities
  has_many :leads
  has_many :issues
  has_many :appointments, dependent: :destroy
  has_many :experience_points
  has_many  :notes, as: :notable, dependent: :destroy
  has_and_belongs_to_many :offerings
  has_many :enrollment_changings, class_name: "EnrollmentChangeRequest", foreign_key: "user_id"
  has_many :enrollment_change_requests, class_name: "EnrollmentChangeRequest", foreign_key: "admin_id"

  scope :active, lambda{where("active = ?", true)}
  scope :employees, lambda{where("role = ? OR role = ? OR role = ? OR role = ? OR role = ? OR role = ?", 'Teacher', 'Teaching Assistant', 'Robotics Instructor', 'Programming Instructor', 'Chess Instructor', 'Admin').where(active: true).order('last_name asc')}
  scope :teachers, lambda{where("role = ?", 'Teacher').where(active: true).order('last_name asc')}
  scope :teaching_assistants, lambda{where("role = ?", 'Teaching Assistant').where(active: true).order('last_name asc')}

  def full_name
      first_name + " " + last_name
  end

  def self.search(search)
    if search
       where('lower(first_name) LIKE ? OR lower(last_name) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%")
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
end
