class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :filename, :content_type, :file_size, :file, :problem_ids, :activity_ids, :lesson_ids

  has_many :problems, :through => :resourcings, :source => :resourceable, :source_type => "Problem"
  has_many :activities, :through => :resourcings, :source => :resourceable, :source_type => "Activity"
  has_many :lessons, :through => :resourcings, :source => :resourceable, :source_type => "Lesson"
  has_many :resourcings

  mount_uploader :file, FileUploader

  before_create :default_name
  before_save :update_file_attributes

  private

  def default_name
    self.filename ||= File.basename(file.filename, '.*').titleize
  end

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
    end
  end

end
