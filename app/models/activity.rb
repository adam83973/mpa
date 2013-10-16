class Activity < ActiveRecord::Base
  attr_accessible :content, :objective, :source, :title, :variations, :course_ids, :image, :remove_image, :remote_image_url, :resource_ids, :setup, :standard_ids

  has_many :resourcings, as: :resourceable
  has_many :resources, through: :resourcings

  has_and_belongs_to_many :courses
  has_and_belongs_to_many :standards

  mount_uploader :image, ImageUploader

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      activity = find_by_id(row["id"]) || new
      activity.attributes = row.to_hash.slice(*accessible_attributes)
      activity.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |activity|
        csv << activity.attributes.values_at(*column_names)
      end
    end
  end

end
