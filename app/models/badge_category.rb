class BadgeCategory < ActiveRecord::Base
  #attr_accessible :name, :write_up_required, :multiple, :parent_can_request

  has_many :badges
end
