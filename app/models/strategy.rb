class Strategy < ActiveRecord::Base
  has_and_belongs_to_many :problems
end
