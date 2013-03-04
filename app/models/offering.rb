class Offering < ActiveRecord::Base
  attr_accessible :comments, :course_id, :day, :graduation_year, :location_id, :time, :user_id
  belongs_to :location
  belongs_to :course
  belongs_to :user
  has_many :students 
end
