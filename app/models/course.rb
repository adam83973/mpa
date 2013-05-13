class Course < ActiveRecord::Base
  attr_accessible :course_name, :description
  has_many :offerings
  has_many :lessons
  has_many :grades

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      course = find_by_id(row["id"]) || new
      course.attributes = row.to_hash.slice(*accessible_attributes)
      course.save!
    end
  end
end
