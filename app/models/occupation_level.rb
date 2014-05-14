class OccupationLevel < ActiveRecord::Base
  attr_accessible :level, :notes, :points, :privileges, :rewards, :occupation_id, :bonus_credits

  belongs_to :occupation

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
