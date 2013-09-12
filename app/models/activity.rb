class Activity < ActiveRecord::Base
  attr_accessible :content, :objective, :source, :title, :variations, :course_ids, :image, :remove_image, :remote_image_url, :resource_ids, :setup, :standard_ids

  has_many :resourcings, :as => :resourceable
  has_many :resources, :through => :resourcings

  has_and_belongs_to_many :courses
  has_and_belongs_to_many :standards

  mount_uploader :image, ImageUploader

end
