class Occupation < ActiveRecord::Base
  has_many :occupation_levels
  has_many :experiences
  has_many :courses
end
