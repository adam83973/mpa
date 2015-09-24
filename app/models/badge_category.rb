class BadgeCategory < ActiveRecord::Base
  attr_accessible :name, :write_up_required

  has_many :badges
end
