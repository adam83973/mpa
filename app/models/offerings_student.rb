class OfferingsStudent < ActiveRecord::Base
  attr_accessible :offering_id, :student_id

  # join table. Table name: offerings_students

  belongs_to :student
  belongs_to :offering

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      studoffering = new
      studoffering.attributes = row.to_hash.slice(*accessible_attributes)
      studoffering.save!
    end
  end
end