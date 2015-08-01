class Badge < ActiveRecord::Base

  attr_accessible :image, :name, :file, :filename, :experience_id, :remove_image,
                  :requirements, :badge_category_id

  has_and_belongs_to_many :students
  belongs_to :experience

  mount_uploader :image, FileUploader

  belongs_to :category, class_name: 'BadgeCategory', foreign_key: "badge_category_id"
end
