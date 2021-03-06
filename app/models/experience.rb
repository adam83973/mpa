class Experience < ActiveRecord::Base

  validates_presence_of :points, :name

  has_paper_trail if Rails.env.development? || Rails.env.production?

  has_many :experience_points
  has_many :resourcings, as: :resourceable
  has_many :resources, through: :resourcings
  belongs_to :occupation
  has_one :badge

  mount_uploader :image, ImageUploader

  accepts_nested_attributes_for :badge

  before_validation :mark_badge_for_destruction

  CATEGORY = [
              "Mathematics",
              "Engineering",
              "Chess",
              "In-Class",
              "Homework",
              "Mastery Website",
              "School",
              "Programming"
             ]

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      experience = find_by_id(row["id"]) || new
      experience.attributes = row.to_hash.slice(*accessible_attributes)
      experience.save!
    end
  end

  def mark_badge_for_destruction
    if badge && badge.name.blank?
      badge.mark_for_destruction
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |experience|
        csv << experience.attributes.values_at(*column_names)
      end
    end
  end
end
