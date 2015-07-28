class Badge < ActiveRecord::Base

  attr_accessible :image, :name, :file, :filename, :experience_id, :remove_image, :requirements

  has_and_belongs_to_many :students
  belongs_to :experience

  mount_uploader :image, FileUploader
end
