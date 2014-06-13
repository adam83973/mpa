class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  validates_presence_of :first_name, :last_name, :role

  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :password, :current_password, :password_confirmation, :remember_me, :offering_ids
  attr_accessible :active, :address, :admin, :first_name, :has_key, :last_name, :location_id, :passion, :phone, :role, :shirt_size, :infusion_id, :last_payment

  attr_accessor :current_password

  has_many :notes
  belongs_to :location
  has_many :students, :through => :offerings
  has_many :students
  has_many :leads
  has_many :experience_points
  has_many  :notes, as: :notable
  has_and_belongs_to_many :offerings

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

  #parent methods
  def parent?
    ["Parent"].include?(self.role)
  end

  def active_students?
    students.any? { |s| s.status == "Active" }
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
      Infusionsoft.contact_add_to_group(infusion_id, 1648)
    end

    if students
      students.each do |student|
        student.update_attributes status: "Inactive"
        student.update_attributes end_date: Date.today
      end
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
