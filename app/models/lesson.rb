class Lesson < ActiveRecord::Base
  attr_accessible :assesment, :assesment_key, :assignment, :assignment_key, :course_id, :name, :week

  belongs_to :course 
  has_many :assignments
end
