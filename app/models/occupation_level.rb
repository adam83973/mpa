class OccupationLevel < ActiveRecord::Base

  belongs_to :occupation
  belongs_to :product

  mount_uploader :image, ImageUploader

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      o_level = find_by_id(row["id"]) || new
      o_level.attributes = row.to_hash.slice(*accessible_attributes)
      o_level.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |o_level|
        csv << o_level.attributes.values_at(*column_names)
      end
    end
  end
end
