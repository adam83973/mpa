class Standard < ActiveRecord::Base

  belongs_to :course
  has_many :lessons
  has_and_belongs_to_many :problems
  has_and_belongs_to_many :activities

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      standard = find_by_id(row["id"]) || new
      standard.attributes = row.to_hash.slice(*accessible_attributes)
      standard.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |standard|
        csv << standard.attributes.values_at(*column_names)
      end
    end
  end
end
