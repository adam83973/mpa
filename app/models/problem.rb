class Problem < ActiveRecord::Base
  attr_accessible :answer, :desc, :methods, :source, :title, :variations, :course_ids, :strategy_ids
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :strategies
end


