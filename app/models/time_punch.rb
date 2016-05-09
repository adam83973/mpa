class TimePunch < ActiveRecord::Base
  #attr_accessible :comment, :in, :modified, :out
  belongs_to :student
end
