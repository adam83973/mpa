namespace :operations do
  #Rake task runs at end of day.
  desc "Perform various maintenance tasks."
  task maintenance: :environment do
    start_date
    start_hold
    restart_date
    end_date
    deactivate_parents
  end
end

def start_hold
  #change students with start_hold_date, and restart_date to
  # have a status of hold
  students = Student.where("start_hold_date = ?", Date.today)

  #cycle through students and set status to hold if student has end date for current day
  students.each do |student|
    if student.start_hold_date <= Date.today && student.status == "Active"
      #set status to hold
      student.update_attribute :status, "Hold"
      student.update_attribute :hold_status, 0
    end
  end
end

def restart_date
  #pull all students with restart date equal to tomorrows date
  students = Student.where("restart_date = ?", Date.today)

  #cycle through students and set status to active if student has restart date for the next day
  students.each do |student|
    if student.restart_date == Date.today
      #set status to Active
      student.update_attribute :status, "Active"
      if !student.user.active?
      #make sure student's parent is active, if not, set parent status to active
        student.user.update_attribute :active, true
      end
    end
  end
end

def start_date
  #script run
  #pull all students with start date equal to todays date
  students = Student.where("start_date = ?", Date.today)

  #cycle through students and set status to active if student has start date for current day
  students.each do |student|
    if student.start_date == Date.today && student.status == "Inactive"
      #set status to Active
      student.update_attribute :status, "Active"
      #make sure student's parent is active, if not, set parent status to active
      if !student.user.active?
        student.user.update_attribute :active, true
      end
    end
  end
end

def end_date
  #pull all students with end date equal to curent day's date
  students = Student.where("end_date = ?", Date.today)

  #cycle through students and set status to inactive if student has end date for current day
  students.each do |student|
    if student.end_date == Date.today && student.status == "Active"
      #set status to inactive
      student.update_attribute :status, "Inactive"
    end
  end
end

def deactivate_parents
  parents = User.where("role = ? AND active = ?", "Parent", true)
  parents.each do |p|
    #parent is not dectivated if student has a future start_date or a restart_date
    unless p.active_students?
      p.update_attribute :active, false
      #add logic to allow opt out of drop campaign
      #Infusionsoft.contact_add_to_group(p.infusion_id, 1648)
    end
  end
end

# --- return from hold tasks ---

# def return_from_hold_notification
#   This method should send an email to parents who have a student who have left, but who have
#   a probable return date 14 days from now.
# end
