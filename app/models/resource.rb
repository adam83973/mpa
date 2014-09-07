class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :filename, :content_type, :file_size, :file, :problem_ids, :activity_ids, :lesson_ids, :experience_ids, :category

  has_many :problems, :through => :resourcings, :source => :resourceable, :source_type => "Problem"
  has_many :activities, :through => :resourcings, :source => :resourceable, :source_type => "Activity"
  has_many :lessons, :through => :resourcings, :source => :resourceable, :source_type => "Lesson"
  has_many :experiences, :through => :resourcings, :source => :resourceable, :source_type => "Experience"
  has_many :resourcings

  mount_uploader :file, FileUploader

  before_create :default_name
  before_save :update_file_attributes
  after_save :add_resource_to_lesson

  CATEGORIES = ["Assignments", "Assignment Keys", "Teacher Resource", "In-Class", "Miscelaneous", "Problem", "Games"]

  def is_lesson?
    default_name
    !!(self.filename =~ /(?<course>\w*.\w*.\w*)\s*(?<week>[0-9]|[1-9][0-9])\s*-{1}\s*(?<lesson>\b\w.\w.*)/)
  end

  def is_lesson_key?
    default_name
    !!(self.filename =~ /(?<course>\w*.\w*.\w*)\s*(?<week>[0-9]|[1-9][0-9])\s*-{1}\s*(?<lesson>\b\w.\w.*).*(?<key>\bKEY\b)/)
  end

  def is_inclass?
    default_name
    !!(self.filename =~ /(?<course>\w*.\w*.\w*)\s*(?<week>[0-9]|[1-9][0-9])\s*-{1}\s*(?<lesson>\b\w.*).*(?<in-class>\bIN-CLASS\b)/)
  end

  def is_teacher_resource?
    default_name
    !!(self.filename =~ /(?<course>\w*.\w*.\w*)\s*(?<week>[0-9]|[1-9][0-9])\s*-{1}\s*(?<lesson>\b\w.\w.*).*(?<teacher-resource>\s*\bTEACHER RESOURCE\b\s*)/)
  end

  private

  def add_resource_to_lesson
    lesson_regex = /(?<course>\w*.\w*.\w*)\s(?<week>[0-9]|[1-9][0-9])\s-{1}[\s-]*(?<lesson>\b\w.\w.*)/
    key_regex = /(?<course>\w*.\w*.\w*)\s(?<week>[0-9]|[1-9][0-9])\s-{1}\s(?<lesson>\b\w.\w.*).*(?<key>\bKEY\b)/
    if self.is_lesson_key?
      l = key_regex.match(self.filename)
      if l
        lessons = Lesson.includes(:standard).where("week = ?", "#{l[:week]}")
        lessons.each do |lesson|
          if lesson.course_name == l[:course]
            lesson.assignment_key ||= self.id
            lesson.save
          end
        end
      end
    elsif self.is_teacher_resource? || self.is_inclass?
      r = lesson_regex.match(self.filename)
      if r
        lessons = Lesson.where("week = ?", "#{r[:week]}")
        lessons.each do |lesson|
          if lesson.course_name == r[:course]
            lesson.resources << self
          end
        end
      end
    elsif self.is_lesson?
      r = lesson_regex.match(self.filename)
      if r
        lessons = Lesson.where("week = ?", "#{r[:week]}")
        lessons.each do |lesson|
          if lesson.course_name == r[:course]
            lesson.assignment ||= self.id
            lesson.save
          end
        end
      end
    else
    end
  end

  def default_name
    self.filename ||= File.basename(file.filename, '.*').gsub("_", " ")
  end
    #regex for class lesson title
    #/(?<course>\w+.\w+)\s(?<week>\d)\s-{1}\s(?<lesson>\b\w*)/
    #regex for class lesson KEY title
    #/(?<course>\w+.\w+).(?<week>\d)\s-{1}\s(?<lesson>\b\w*).(?<key>\bKEY\b)/
  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
      if is_lesson? && is_lesson_key?
        self.category = "Assignment Keys"
      elsif is_lesson? && is_teacher_resource?
        self.category = "Teacher Resource"
      elsif is_lesson? && is_inclass?
        self.category = "In-Class"
      elsif is_lesson?
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