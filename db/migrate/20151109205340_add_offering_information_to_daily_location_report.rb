class AddOfferingInformationToDailyLocationReport < ActiveRecord::Migration
  def change
    add_column :daily_location_reports, :offering_information, :text
  end
end
