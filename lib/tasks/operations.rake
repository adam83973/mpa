namespace :operations do
  #Rake task runs at end of day.
  desc "Perform various maintenance tasks."
  task maintenance: :environment do
    start_date
    start_hold
    restart_date
    end_date
    deactivate_parents
    opportunitities_maintenance
    flag_parents_for_active_registrations
  end
  task reports: :environment do
    send_assignments_report
    send_opportunities_report
  end
end

###### Enrollment/Registrations Management ######

def start_hold
  #Look for registrations with start hold date. Change status to inactive.
  registrations = Registration.where("hold_date <= ? AND status = ?", Date.today, 1)

  #cycle through students and set status to hold if student has end date for current day
  registrations.each do |registration|
    if registration.hold_date <= Date.today && registration.status == 1
      #set status to hold
      registration.update_attribute :status, 3
    end
  end
end

def restart_date
  #pull all students with restart date equal to tomorrows date
  registrations = Registration.where("restart_date = ?", Date.today)

  #cycle through students and set status to active if student has restart date for the next day
  registrations.each do |registration|
    if registration.restart_date == Date.today
      #set status to Active
      registration.update_attribute :status, 1
      if registration.student.user && !(registration.student.user.active?)
      #make sure student's parent is active, if not, set parent status to active
        registration.student.user.update_attribute :active, true
      end
    end
  end
end

def start_date
  #pull all students with start date equal to todays date
  registrations = Registration.where("start_date = ?", Date.today)

  #cycle through students and set status to active if student has start date for current day
  registrations.each do |registration|
    if registration.start_date == Date.today && registration.status == 0
      #set status to Active
      registration.update_attribute :status, 1
      #make sure student's parent is active, if not, set parent status to active
      if registration.student.user && !(registration.student.user.active?)
        registration.student.user.update_attribute :active, true
      end
    end
  end
end

def end_date
  #pull all students with end date equal to curent day's date
  registrations = Registration.where("end_date = ?", Date.today)

  #cycle through students and set status to inactive if student has end date for current day
  registrations.each do |registration|
    if registration.end_date == Date.today && registration.status == 1
      #set status to inactive
      registration.update_attribute :status, 3
    end
  end
end

def deactivate_parents
  parents = User.where("role = ? AND active = ?", "Parent", true)
  parents.each do |parent|
    #parent is not dectivated if student has a future start_date or a restart_date
    unless parent.active_students?
      parent.update_attribute :active, false
    end
  end
end

def flag_parents_for_active_registrations
  parents = User.where("role = ?", "Parent")
  parents.each do |parent|
    if parent.active_registrations.any?
      parent.update_attribute :active_registration, true
    end
  end
end

###### Opportunity Management ######

def opportunitities_maintenance
  # Create needs action notes for opportunities that do not have needs action notes and haven't been updated in over a week.

  active_opportunities = Opportunity.active

  active_opportunities.each do |opportunity|
    user = opportunity.user
    if user && opportunity.created_at < Date.today - 8.days
      unless user.has_action_note?
        note = user.notes.build({
                                  content: "Please review and update active opportunities for #{user.full_name}. Please note their account with an update and leave a needs action note if there are outstanding opportunities that have not been marked as won or lost.",
                                  user_id: User.system_admin_id,
                                  action_date: Date.today,
                                  location_id: opportunity.location_id})
        note.save
      end
    end
  end
end

###### Admin Reports ######

def send_assignments_report
  users = User.where(assignments_reports: true)

  users.each do |user|
    ReportMailer.weekly_assignments_report(user).deliver_now
  end
end

def send_opportunities_report
  users = User.where(opportunities_reports: true)

  users.each do |user|
    ReportMailer.weekly_opportunities_report(user).deliver_now
  end
end
