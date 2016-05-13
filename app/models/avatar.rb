class Avatar < ActiveRecord::Base
  #attr_accessible :image, :remove_image, :remote_image_url, :name

  has_many :students

  mount_uploader :image, ImageUploader
end
