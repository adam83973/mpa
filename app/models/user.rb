class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  validates_presence_of :first_name, :last_name, :role

  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :password, :current_password, :password_confirmation, :remember_me, :offering_ids,
                  :active, :address, :admin, :first_name, :has_key, :last_name, :location_id, :passion,
                  :phone, :role, :shirt_size, :infusion_id, :last_payment, :active_subscription, :send_password_link, :opportunity_id, :subscription_count, :balance_due

  attr_accessor :current_password, :opportunity_id, :send_password_link

  has_many :notings, class_name: "Note", foreign_key: "user_id"
  belongs_to :location
  has_many :students, :through => :offerings
  has_many :students
  has_many :registrations, :through => :students
  has_many :opportunities
  has_many :leads
  has_many :issues
  has_many :experience_points
  has_many  :notes, as: :notable
  has_and_belongs_to_many :offerings
  has_many :enrollment_changings, class_name: "EnrollmentChangeRequest", foreign_key: "user_id"
  has_many :enrollment_change_requests, class_name: "EnrollmentChangeRequest", foreign_key: "admin_id"

  scope :active, lambda{where("active = ?", true)}
  scope :employees, lambda{where("role = ? OR role = ? OR role = ? OR role = ? OR role = ?", 'Teacher', 'Teaching Assistant', 'Robotics Instructor', 'Programming Instructor', 'Chess Instructor').where(active: true).order('last_name asc')}

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
    registrations.any? { |r| (0..2).cover?(r.status) || (r.start_date && (r.start_date >= Date.today)) }
  end

  # def deactivate
  #   if self.active = true
  #     self.toggle(:active)
  #   end
  #   if self.students
  #     students = self.students
  #     students.each do |each|
  #       student.update_attributes status: "Inactive"
  #     end
  #   end
  # end

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
    if self.parent?
      active_subscriptions = Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => infusion_id}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] )
      active_subscriptions.any? { |s| s["Status"] == "Active" }
    end
  end

  def subscriptions_count
    if self.parent?
      active_subscriptions = Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => infusion_id}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] )
      active_subscriptions.count { |s| s["Status"] == "Active" }
    end
  end



  def last_payment_infusion
    if self.infusion_id && self.role == 'Parent' && !self.last_payment.nil?
      JSON::parse(last_payment)
    else
      return []
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
end
