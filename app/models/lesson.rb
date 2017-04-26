class Lesson < ActiveRecord::Base

  has_many :videos
  has_many :resourcings, as: :resourceable
  has_many :resources, through: :resourcings
  has_and_belongs_to_many :problems
  belongs_to :standard
  has_many :grades
  belongs_to :course
  has_many  :notes, as: :notable, dependent: :destroy

  if Rails.env.production?
    searchable do
      text :name
      text :course_name
      integer :week
      text :course_name_and_week
    end
  end

  def title
      course.name + "-" + week.to_s + ": " + name
  end

  def course_name
    course.name
  end

  def course_name_and_week
    "#{course.name} #{week}"
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      lesson = find_by_id(row["id"]) || new
      lesson.attributes = row.to_hash.slice(*accessible_attributes)
      lesson.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |lesson|
        csv << lesson.attributes.values_at(*column_names)
      end
    end
  end

end
