class Offering < ActiveRecord::Base
  attr_accessible :comments, :course_id, :day, :graduation_year, :location_id, :time, :user_ids, :active, :classroom

  validates_presence_of :course_id, :day, :time, :location_id

  belongs_to :location
  belongs_to :course
  has_one :occupation, through: :course
  has_and_belongs_to_many :users
  has_and_belongs_to_many :students

  def name
    course.course_name
  end

  def offering_name_dashboard
      course.course_name + " | " + day[0..2] + " - " + time.strftime("%I:%M %p")
  end

  def offering_name
      course.course_name + " | " + location.name + " | " + day + " - " + time.strftime("%I:%M %p")
  end

  def returning_students_count
      self.students.where("status = ? AND restart_date is NOT NULL", "Hold").count
  end

  def active_students_count
      self.students.find_all_by_status("Active").count
  end

  def self.search(search)
    if search
      joins(:course).where('lower(courses.course_name) LIKE ?', "%#{search.downcase}%")
    end
  end

  def type
    id = self.course_id
    case id
    when 1..9
      "Mathematics"
    when 10
      "Chess"
    when 11
      "Engineering"
    when 13 || 17
      "Mathematics"
    when 15
      "Programming"
    when 18
      "Engineering"
    else
      ""
    end
  end

  def at_capacity?
    total_students = returning_students_count + active_students_count
    math_class_ids = (1..10).to_a << 13 << 17
    tech_class_ids = [11, 12, 15, 16]
    if math_class_ids.include?(self.course.id) && 10 - total_students <= 0
      true
    elsif self.course.id == 10 && 15 - total_students <= 0
      true
    elsif tech_class_ids.include?(self.course.id) && 8 - total_students <= 0
      true
    else
      false
    end
  end

  def students_wait_listed?
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |offering|
        csv << offering.attributes.values_at(*column_names)
      end
    end
  end

  def parent_email_to_csv
    CSV.generate do |csv|
      students.each do |student|
        email = Array.new
        email << "#{student.user.full_name} <#{student.user.email}>,"
        csv << email
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      offering = find_by_id(row["id"]) || new
      offering.attributes = row.to_hash.slice(*accessible_attributes)
      offering.save!
    end
  end
end
