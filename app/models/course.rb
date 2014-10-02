class Course < ActiveRecord::Base
  attr_accessible :course_name, :description, :grade, :occupation_id

  has_many :offerings
  has_many :opportunities
  has_many :standards
  has_many :lessons, through: :standards
  has_and_belongs_to_many :problems
  belongs_to :occupation

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |course|
        csv << course.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      course = find_by_id(row["id"]) || new
      course.attributes = row.to_hash.slice(*accessible_attributes)
      course.save!
    end
  end
end
