class Experience < ActiveRecord::Base
  attr_accessible :category, :content, :name, :experience_points_attributes

  has_many :experience_points

  accepts_nested_attributes_for :experience_points
end
