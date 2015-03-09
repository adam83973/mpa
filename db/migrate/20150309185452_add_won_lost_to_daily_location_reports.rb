class AddWonLostToDailyLocationReports < ActiveRecord::Migration
  def change
    add_column :daily_location_reports, :opportunities_won_count, :integer, default: 0
    add_column :daily_location_reports, :opportunities_lost_count, :integer, default: 0
  end
end
