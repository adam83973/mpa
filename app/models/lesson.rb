class Lesson < ActiveRecord::Base
  attr_accessible :assesment, :assesment_key, :assignment, :assignment_key, :course_id, :name, :week
end
