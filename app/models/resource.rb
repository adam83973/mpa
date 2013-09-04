class Resource < ActiveRecord::Base
  attr_accessible :filename, :content_type, :file_size, :file

  has_many :problems, :through => :resourcing, :source => :resourceable, :source_type => "Problems"

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
