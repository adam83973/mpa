class Badge < ActiveRecord::Base

  has_paper_trail if Rails.env.development? || Rails.env.production?

  has_and_belongs_to_many :students
  has_many :badge_requests, dependent: :destroy
  belongs_to :experience
  belongs_to :category, class_name: 'BadgeCategory', foreign_key: "badge_category_id"
  belongs_to :module, class_name: 'BadgeModule', foreign_key: "module_id"

  mount_uploader :image, FileUploader

  scope :that_parents_can_request, -> { where(parent_can_request: true)  }

  # electronic - 0, physical - 1
  SUBMISSION_TYPES = ["Electronic", "Physical"]

  def category_name
    category.name
  end
end
