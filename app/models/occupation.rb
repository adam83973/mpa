class Occupation < ActiveRecord::Base
  attr_accessible :description, :title


  has_and_belongs_to_many :students
  has_many :levels
end
