class Problem < ActiveRecord::Base

  validates_presence_of :title, :activity_type
  validates :title, uniqueness: true

  has_many :resourcings, :as => :resourceable
  has_many :resources, :through => :resourcings

  has_and_belongs_to_many :courses
  has_and_belongs_to_many :strategies
  has_and_belongs_to_many :standards
  has_and_belongs_to_many :lessons

  mount_uploader :image, ImageUploader

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      problem = find_by_id(row["id"]) || new
      problem.attributes = row.to_hash.slice(*accessible_attributes)
      problem.save!
    end
  end

end
