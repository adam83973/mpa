class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :filename, :content_type, :file_size, :file, :problem_ids

  has_many :problems, :through => :resourcings, :source => :resourceable, :source_type => "Problem"
  has_many :resourcings

  mount_uploader :file, FileUploader

  before_create :default_name
  before_save :update_file_attributes

  #one convenient method to pass jq_upload the necessary information
  # def to_jq_upload
  #   {
  #     "name" => read_attribute(:file),
  #     "size" => file.size,
  #     "url" => file.url,
  #     "thumbnail_url" => file.thumb.url,
  #     "delete_url" => id,
  #     "delete_type" => "DELETE" 
  #   }
  # end

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
