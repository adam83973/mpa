class Experience < ActiveRecord::Base
  attr_accessible :category, :content, :name, :points, :image, :remove_image, :resource_ids, :remote_image_url

  validates_presence_of :points, :category, :name

  has_many :experience_points
  has_many :resourcings, as: :resourceable
  has_many :resources, through: :resourcings

  mount_uploader :image, ImageUploader

  CATEGORY = [ "Mathematics", "Engineering", "Chess", "In-Class", "Homework", "Mastery Website", "School", "Programming"]

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      experience = find_by_id(row["id"]) || new
      experience.attributes = row.to_hash.slice(*accessible_attributes)
      experience.save!
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
