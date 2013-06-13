class Experience < ActiveRecord::Base
  attr_accessible :category, :content, :name, :points, :image, :remove_image

  has_many :experience_points

  mount_uploader :image, ImageUploader
end
