class Problem < ActiveRecord::Base

  attr_accessible :answer, :desc, :methods, :source, :title, :variations, :course_ids, :strategy_ids, :image, :remove_image, :remote_image_url, :resource_ids, :standard_ids, :activity_type, :setup

  validates_presence_of :title, :activity_type
  
  has_many :resourcings, :as => :resourceable
  has_many :resources, :through => :resourcings

  has_and_belongs_to_many :courses
  has_and_belongs_to_many :strategies
  has_and_belongs_to_many :standards

  mount_uploader :image, ImageUploader

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      problem = find_by_id(row["id"]) || new
      problem.attributes = row.to_hash.slice(*accessible_attributes)
      problem.save!
    end
  end

end


