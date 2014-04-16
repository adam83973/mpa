namespace :report do
  desc "Update parent's information with last payment date."
  task location_daily: :environment do
    daily_batch
  end
end

def daily_batch
  locations = Location.all
  locations.each do |location|
    @student_count = location.active_students.count
    @parent_sign_in_count = User.where("current_sign_in_at >= ? AND role = ? AND location_id = ?", Time.now.beginning_of_day, "Parent", location.id).count
    @student_drops = location.students.where("end_date = ?", Time.now.beginning_of_day.to_date).count
    @student_adds = location.students.where("start_date = ?", Time.now.beginning_of_day.to_date).count

    DailyLocationReport.create!(
                location_id:      location.id,
                total_enrollment: @student_count,
                parent_logins:    @parent_sign_in_count,
                drop_count:       @student_drops,
                add_count:        @student_adds)
  end
end
