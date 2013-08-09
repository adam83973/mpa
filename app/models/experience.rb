class Experience < ActiveRecord::Base
  attr_accessible :category, :content, :name, :points, :image, :remove_image

  validates_presence_of :points, :category, :name

  has_many :experience_points

  mount_uploader :image, ImageUploader
end
