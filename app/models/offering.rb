class Offering < ActiveRecord::Base
  attr_accessible :comments, :course_id, :day, :graduation_year, :location_id,
                  :time, :user_ids, :active, :classroom, :hidden, :day_number

  validates_presence_of :course_id, :day, :time, :location_id

  belongs_to :location
  belongs_to :course
  has_one :occupation, through: :course
  has_and_belongs_to_many :users
  has_many :registrations
  has_many :students, through: :registrations
  # has_and_belongs_to_many :students

  scope :visible, lambda{ where("hidden = ? AND active = ?", false, true) }
  scope :active,  lambda{ where("active = ?", true) }

  before_save :set_day_number

  searchable do
    text :offering_name
    integer :course_id
    time :time
    integer :user_ids, :multiple => true
  end

  def name
    course.course_name
  end

  def offering_name_dashboard
    course.course_name + " | " + day[0..2] + " - " + time.strftime("%I:%M %p")
  end

  def offering_name
    course.course_name + " | " + location.name + " | " + day + " - " + time.strftime("%I:%M %p")
  end

  def offering_trial_name
    course.course_name + " | " + day[0..2] + " - " + time.strftime("%I:%M %p")
  end

  def returning_students_count
    self.registrations.where("status = ?", 2).count
  end

  def set_day_number
    day_number = Date::DAYNAMES.index(day).to_i
  end

  def active_students_count
    self.registrations.where("status = ? OR status = ?", 1, 0).count
  end

  # def self.search(search)
  #   if search
  #     joins(:course).where('lower(courses.course_name) LIKE ?', "%#{search.downcase}%")
  #   end
  # end

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

  def capacity
    if course
      course.capacity
    end
  end

  def at_capacity?
    total_students = returning_students_count + active_students_count
    (course.capacity.to_i - total_students.to_i).to_i <= 0
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
        if student.is_active?
          email << "#{student.user.full_name} <#{student.user.email}>,"
        end
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
