class Badge < ActiveRecord::Base

  #attr_accessible :image, :name, :file, :filename, :experience_id, :remove_image,
                  :requirements, :badge_category_id, :submission_type, :write_up_required,
                  :multiple, :requires_approval, :parent_can_request, :module_id

  has_paper_trail

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
