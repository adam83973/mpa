class Location < ActiveRecord::Base
  attr_accessible :address, :city, :franchise, :name, :state, :zip
  has_many :offerings
  has_many :users
  has_many :students, :through => :offerings

  def students_added_last_30
    self.students.where("start_date < ? and start_date > ?", Date.today, 30.days.ago)
  end

  def students_dropped_last_30
    self.students.where("end_date < ? and end_date > ?", Date.tomorrow, 30.days.ago)
  end

  def active_students
      self.students.where("status = ?", "Active") if self.students
  end

  def restarting_students
      self.students.where("status = ? AND restart_date < ?", "Hold", 20.days.from_now)
  end

  def active_offerings
      self.offerings.where("active = ?", true) if self.offerings
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      location = find_by_id(row["id"]) || new
      location.attributes = row.to_hash.slice(*accessible_attributes)
      location.save!
    end
  end
end
