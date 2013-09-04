class Resource < ActiveRecord::Base
  attr_accessible :filename, :content_type, :file_size, :file, :problem_ids

  has_many :problems, :through => :resourcings, :source => :resourceable, :source_type => "Problem"
  has_many :resourcings

  mount_uploader :file, FileUploader

  before_save :update_file_attributes
  
  private
  
  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
    end
  end

end
