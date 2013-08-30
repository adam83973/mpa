class Problem < ActiveRecord::Base
  attr_accessible :answer, :desc, :methods, :source, :title, :variations, :course_ids, :strategy_ids, :image, :remove_image, :remote_image_url
  
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :strategies

  mount_uploader :image, ImageUploader
end


