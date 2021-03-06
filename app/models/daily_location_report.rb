class DailyLocationReport < ActiveRecord::Base
  #attr_accessible :add_count, :drop_count, :location_id, :parent_logins, :total_enrollment, :hw_help_count, :assessment_count, :opportunities_won_count, :opportunities_lost_count, :offering_information

  serialize :offering_information
  
  belongs_to :location

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |report|
        csv << report.attributes.values_at(*column_names)
      end
    end
  end
end
