class BadgeModule < ActiveRecord::Base
  #attr_accessible :badge_category_id, :name

  belongs_to :badge_category
  has_many :badges, :class_name => "Badge", :source => :badge, foreign_key: "module_id"
end
