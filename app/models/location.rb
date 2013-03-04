class Location < ActiveRecord::Base
  attr_accessible :address, :city, :franchise, :name, :state, :zip
  has_many :offerings
  has_many :users
end
