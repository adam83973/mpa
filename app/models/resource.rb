class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :problems,     :through => :resourcings, :source => :resourceable, :source_type => "Problem"
  has_many :activities,   :through => :resourcings, :source => :resourceable, :source_type => "Activity"
  has_many :lessons,      :through => :resourcings, :source => :resourceable, :source_type => "Lesson"
  has_many :experiences,  :through => :resourcings, :source => :resourceable, :source_type => "Experience"
  has_many :resourcings

  mount_uploader :file, FileUploader

  before_create :default_name
  before_save :update_file_attributes
  after_create :add_resource_to_lesson

  CATEGORIES = ["Assignments", "Assignment Keys", "Teacher Resource", "In-Class", "Miscelaneous", "Problem", "Games"]

  def assignment_regex
    #regex to match filename 'Course Week_Number - Lesson_Name ASSIGNMENT'
    /(?<course>\b\w.*)\s(?<week>[0-9]|[1-9][0-9])\s-{1}[\s-]*(?<lesson>\b\w.*).*(?<type>\bASSIGNMENT\b)/
  end

  def key_regex
    #regex to match filename 'Course Week_Number - Lesson_Name KEY'
    /(?<course>\b\w.*)\s(?<week>[0-9]|[1-9][0-9])\s-{1}[\s-]*(?<lesson>\b\w.*).*(?<type>\bKEY\b)/
  end

  def resource_regex
    #regex to match filename 'Course Week_Number - Resource_Name RESOURCE'
    /(?<course>\b\w.*)\s(?<week>[0-9]|[1-9][0-9])\s-{1}[\s-]*(?<lesson>\b\w.*).*(?<type>\bRESOURCE\b)/
  end

  def is_assignment?
    default_name
    !!(self.filename =~ assignment_regex)
  end

  def is_key?
    default_name
    !!(self.filename =~ key_regex)
  end

  def is_resource?
    default_name
    !!(self.filename =~ resource_regex)
  end

  def filename_abr
    self.filename[0..30].gsub(/\s\w+\s*$/, '...')
  end

  def filename_created_at
    "#{self.filename[0..50].gsub(/\s\w+\s*$/, '...')} (Added: #{self.created_at.strftime('%m/%d/%Y')})".html_safe
  end

  private

  def add_resource_to_lesson
    puts '********** Processing Uploaded Resource **********'
    if is_assignment?
      puts '********** Resource is an assignment. **********'
      resource_information = assignment_regex.match(filename)
      if resource_information
        lessons = Lesson.where("week = ?", "#{resource_information[:week].strip}")
        lessons.each do |lesson|
          if lesson.course_name == resource_information[:course]
            lesson.assignment = id
            lesson.save!
            puts '********** Resource Added to Lesson. **********'
          end
        end
      end
    elsif is_key?
      resource_information = key_regex.match(filename)
      if resource_information
        lessons = Lesson.where("week = ?", "#{resource_information[:week].strip}")
        lessons.each do |lesson|
          if lesson.course_name == resource_information[:course].strip
            lesson.assignment_key = id
            lesson.save!
          end
        end
      end
    elsif is_resource?
      resource_information = resource_regex.match(filename)
      if resource_information
        lessons = Lesson.where("week = ?", "#{resource_information[:week].strip}")
        lessons.each do |lesson|
          if lesson.course_name == resource_information[:course].strip
            lesson.resources << self
          end
        end
      end
    else
    end
    puts '********** Resource Processing Complete **********'
  end

  def default_name
    self.filename ||= File.basename(file.filename, '.*').gsub("_", " ")
  end

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
      if is_key?
        self.category = "Assignment Keys"
      elsif is_resource?
        self.category = "Teacher Resource"
      elsif is_assignment?
        self.category = "Assignments"
      else
        self.category = "Miscelaneous"
      end
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |resource|
        csv << resource.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      resource = find_by_id(row["id"]) || new
      resource.attributes = row.to_hash.slice(*accessible_attributes)
      resource.save!
    end
  end
end
