class AddTotalEnrollmentToDailyLocationReports < ActiveRecord::Migration
  def change
    add_column :daily_location_reports, :total_enrollment, :integer
  end
end
