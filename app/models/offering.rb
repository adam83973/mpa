class Offering < ActiveRecord::Base
  attr_accessible :comments, :course_id, :day, :graduation_year, :location_id, :time, :user_ids, :active, :classroom

  validates_presence_of :course_id, :day, :time, :location_id

  belongs_to :location
  belongs_to :course
  has_and_belongs_to_many :users
  has_and_belongs_to_many :students

  def offering_name
      course.course_name + " | " + location.name + " | " + day + " - " + time.strftime("%I:%M %p")
  end

  def returning_students_count
      self.students.where("status = ? AND return_date != ?", "Hold", "nil").count
  end

  def active_students_count
      self.students.find_all_by_status("Active").count
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      offering = find_by_id(row["id"]) || new
      offering.attributes = row.to_hash.slice(*accessible_attributes)
      offering.save!
    end
  end
end
