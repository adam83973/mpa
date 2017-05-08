class OfferingsStudent < ActiveRecord::Base

  belongs_to :student
  belongs_to :offering

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      studoffering = new
      studoffering.attributes = row.to_hash.slice(*accessible_attributes)
      studoffering.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |offerings_students|
        csv << offerings_students.attributes.values_at(*column_names)
      end
    end
  end
end
