class Location < ActiveRecord::Base

  #attr_accessible :address, :city, :franchise, :name, :state, :zip, :technical_information

  has_many :opportunities
  has_many :notes
  has_many :messages
  has_many :offerings
  has_many :users
  has_many :leads
  has_many :registrations, through: :offerings
  has_many :students, through: :registrations
  has_many :daily_location_reports
  has_many :appointments
  has_many :badge_requests, through: :students
  has_many :active_registrations, :through => :offerings, class_name: 'Registration', source: :registrations, conditions: "registrations.status IN (0, 1, 2) or registrations.start_date IN ('2015-10-09', '2015-10-14')"

  def admins
    User.where("role = ? AND location_id = ? AND active = ?", "Admin", self.id, true)
  end

  def active_offerings
    self.offerings.active if self.offerings
  end

  def visible_offerings
    self.offerings.visible if self.offerings
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      location = find_by_id(row["id"]) || new
      location.attributes = row.to_hash.slice(*accessible_attributes)
      location.save!
    end
  end
end
