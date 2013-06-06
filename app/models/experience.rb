class Experience < ActiveRecord::Base
  attr_accessible :category, :content, :name, :points

  has_many :experience_points

  validates_presence_of :experience_id
end
