class OfferingsUser < ActiveRecord::Base
  attr_accessible :offering_id, :student_id

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user_offering = new
      user_offering.attributes = row.to_hash.slice(*accessible_attributes)
      user_offering.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |offerings_users|
        csv << offerings_users.attributes.values_at(*column_names)
      end
    end
  end
end