class Experience < ActiveRecord::Base
  attr_accessible :category, :content, :name, :points

  has_many :experience_points

end
