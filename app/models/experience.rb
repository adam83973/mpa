class Experience < ActiveRecord::Base
  attr_accessible :category, :content, :name, :points, :image, :remove_image, :resource_ids, :remote_image_url

  validates_presence_of :points, :category, :name

  has_many :experience_points
  has_many :resourcings, as: :resourceable
  has_many :resources, through: :resourcings

  mount_uploader :image, ImageUploader
end
