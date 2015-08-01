class BadgeCategory < ActiveRecord::Base
  attr_accessible :name

  has_many :badges
end
