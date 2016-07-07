class Strategy < ActiveRecord::Base
  #attr_accessible :name, :problem_ids
  has_and_belongs_to_many :problems
end
