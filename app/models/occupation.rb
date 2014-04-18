class Occupation < ActiveRecord::Base
  attr_accessible :description, :title

  has_many :occupation_levels
  has_many :experiences
  has_many :courses
end
