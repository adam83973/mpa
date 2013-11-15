class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :filename, :content_type, :file_size, :file, :problem_ids, :activity_ids, :lesson_ids, :category

  has_many :problems, :through => :resourcings, :source => :resourceable, :source_type => "Problem"
  has_many :activities, :through => :resourcings, :source => :resourceable, :source_type => "Activity"
  has_many :lessons, :through => :resourcings, :source => :resourceable, :source_type => "Lesson"
  has_many :resourcings

  mount_uploader :file, FileUploader

  before_create :default_name
  before_save :update_file_attributes

  def is_lesson?
    default_name
    !!(self.filename =~ /(?<course>\w+.\w+)\s(?<week>[0-9]|[1-9][0-9])\s-{1}\s(?<lesson>\b\w*)/)
  end

  def is_lesson_key?
    default_name
    !!(self.filename =~ /(?<course>\w+.\w+).(?<week>[0-9]|[1-9][0-9])\s-{1}\s(?<lesson>\b\w*).*(?<key>\bKEY\b)/)
  end

  private

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
