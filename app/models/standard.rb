class Standard < ActiveRecord::Base
  attr_accessible :category, :description, :name, :course_id, :problem_ids, :activity_ids

  belongs_to :course
  has_many :lessons
  has_and_belongs_to_many :problems
  has_and_belongs_to_many :activities
end
