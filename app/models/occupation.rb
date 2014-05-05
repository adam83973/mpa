class Occupation < ActiveRecord::Base
  attr_accessible :description, :title, :bonus_credits

  has_many :occupation_levels
  has_many :experiences
  has_many :courses
end
