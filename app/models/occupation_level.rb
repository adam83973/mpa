class OccupationLevel < ActiveRecord::Base
  attr_accessible :level, :notes, :points, :privileges, :rewards, :occupation_id

  belongs_to :occupation
end
