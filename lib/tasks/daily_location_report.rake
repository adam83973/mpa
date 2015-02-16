namespace :report do
  desc "Update parent's information with last payment date."
  task location_daily: :environment do
    daily_batch
  end
end

def daily_batch
  locations = Location.all
  locations.each do |location|
    @hw_help_appointments = location.appointments.where("time < ? AND time > ? AND reasonId = ?", Time.now.end_of_day, Time.now.beginning_of_day, 37118)
    @assessment_appointments = location.appointments.where("time < ? AND time > ? AND reasonId = ?", Time.now.end_of_day, Time.now.beginning_of_day, 37117)
    @student_assessments_count = @assessment_appointments.count
    @hw_help_appointments_count = @hw_help_appointments.count
    @student_count = location.registrations.active.count
    @parent_sign_in_count = User.where("current_sign_in_at >= ? AND role = ? AND location_id = ?", Time.now.beginning_of_day, "Parent", location.id).count
    @student_drops = location.registrations.where("end_date = ?", Time.now.beginning_of_day.to_date).count
    @student_adds = location.registrations.where("start_date = ?", Time.now.beginning_of_day.to_date).count

    DailyLocationReport.create!(
                location_id:      location.id,
                total_enrollment: @student_count,
                parent_logins:    @parent_sign_in_count,
                drop_count:       @student_drops,
                add_count:        @student_adds,
                hw_help_count:    @hw_help_appointments_count,
                assessment_count: @student_assessments_count)
  end
end
