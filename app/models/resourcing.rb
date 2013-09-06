class Resourcing < ActiveRecord::Base
	attr_accessible :resource_id, :resourceable_id, :resourceable_type
	belongs_to :resource
	belongs_to :resourceable, polymorphic: true
end
