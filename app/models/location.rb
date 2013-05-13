class Location < ActiveRecord::Base
  attr_accessible :address, :city, :franchise, :name, :state, :zip
  has_many :offerings
  has_many :users
  has_many :students, :through => :offerings

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      location = find_by_id(row["id"]) || new
      location.attributes = row.to_hash.slice(*accessible_attributes)
      location.save!
    end
  end
end
