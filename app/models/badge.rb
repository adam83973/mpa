class Badge < ActiveRecord::Base

  attr_accessible :image, :name, :file, :filename, :experience_id, :remove_image,
                  :requirements, :badge_category_id, :submission_type, :write_up_required,
                  :multiple

  has_and_belongs_to_many :students
  has_many :badge_requests, dependent: :destroy
  belongs_to :experience
  belongs_to :category, class_name: 'BadgeCategory', foreign_key: "badge_category_id"

  mount_uploader :image, FileUploader

  # electronic - 0, physical - 1
  SUBMISSION_TYPES = ["Electronic", "Physical"]
end
