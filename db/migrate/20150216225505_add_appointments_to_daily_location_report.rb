class AddAppointmentsToDailyLocationReport < ActiveRecord::Migration
  def change
    add_column :daily_location_reports, :hw_help_count, :integer, default: 0
    add_column :daily_location_reports, :assessment_count, :integer, default: 0
  end
end
