namespace :report do
  desc "Update parent's information with last payment date."
  task location_daily: :environment do
    daily_batch
    cache_offering_information
  end
end

def daily_batch
  locations = Location.all
  locations.each do |location|
    hw_help_appointments = location.appointments.where("time < ? AND time > ?", Time.now.end_of_day, Time.now.beginning_of_day).where(reasonId: 37118).delete_if{|appointment| appointment.status == "CANCELLED" || appointment.status == "DELETED"}
    assessment_appointments = location.appointments.where("time < ? AND time > ?", Time.now.end_of_day, Time.now.beginning_of_day).where(reasonId: 37117).delete_if{|appointment| appointment.status == "CANCELLED" || appointment.status == "DELETED"}
    opportunities_won_count = Opportunity.where(location_id: location.id).where(date_won: Date.today).count.to_i
    opportunities_lost_count = Opportunity.where(location_id: location.id).where(date_lost: Date.today).count.to_i
    student_assessments_count = assessment_appointments.count
    hw_help_appointments_count = hw_help_appointments.count
    student_count = location.registrations.active.count
    parent_sign_in_count = User.where("current_sign_in_at >= ? AND role = ? AND location_id = ?", Time.now.beginning_of_day, "Parent", location.id).count
    student_drops = location.registrations.where("end_date = ?", Time.now.beginning_of_day.to_date).count
    student_adds = location.registrations.where("start_date = ?", Time.now.beginning_of_day.to_date).count

    # Gather information for each locaitons offering by day.
    offerings = location.offerings
    offering_information = Hash.new
    offerings.each_with_index do |offering, i|
      offering_information[i] = offering.as_json
      offering_information[i]['enrollment'] = offering.active_students_count
      offering_information[i]['users'] = {}
      offering.users.each_with_index do |user, n|
        user_info = {}
        user_info['id'] = user.id
        user_info['role'] = user.role
        offering_information[i]['users'][n] = user_info
      end
    end

    DailyLocationReport.create!(
                location_id:              location.id,
                total_enrollment:         student_count,
                parent_logins:            parent_sign_in_count,
                drop_count:               student_drops,
                add_count:                student_adds,
                hw_help_count:            hw_help_appointments_count,
                assessment_count:         student_assessments_count,
                opportunities_won_count:  opportunities_won_count,
                opportunities_lost_count: opportunities_lost_count,
                offering_information:     offering_information
                )
  end
end

def cache_offering_information
  offerings = Offering.where(active: true)

  offerings.each do |offering|
    teacher = offering.users.where(role: 'Teacher').first
    teacher ? teacher_id = teacher.id : teacher_id = nil
    assistant = offering.users.where(role: 'Teaching Assistant').first
    assistant ? assistant_id = assistant.id : assistant_id = nil
    OfferingHistory.create!(
                offering_id:              offering.id,
                course_id:                offering.course_id,
                teacher_id:               teacher_id,
                assistant_id:             assistant_id,
                enrollment:               offering.active_students_count
                )
  ends
end
