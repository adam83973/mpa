namespace :operations do
  #Rake task runs at end of day.
  desc "Perform various maintenance tasks."
  task maintenance: :environment do
    start_date
    start_hold
    restart_date
    end_date
    deactivate_parents
    termination_campaign
  end
end

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
  #script run
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
  parents.each do |p|
    #parent is not dectivated if student has a future start_date or a restart_date
    unless p.active_students?
      p.update_attribute :active, false
      #add logic to allow opt out of drop campaign
      #Infusionsoft.contact_add_to_group(p.infusion_id, 1648)
    end
  end
end

def termination_campaign
  if Date.today.friday?
    parents = User.where(active: false, role: "Parent", active_subscription: false, termination_sequence: false)

    parents.each do |parent|
      if parent.infusion_id
        invoice = Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false).first
        if invoice
          time = invoice['DateCreated'].to_time
          if time < Time.now - 60.days && time > Time.now - 365.days
            Infusionsoft.contact_add_to_group(parent.infusion_id, 2080)
          end
        end
      end
    end
  end
end

def new_users_to_infusionsoft
  users = User.where(created_at: Date.today, infusion_id: nil)

  users.each do |user|
    # search Infusionsoft by email to find lead.
    contact = Infusionsoft.contact_find_by_email(user.email, [:Id])

    if !contact.empty? # if Infusionsoft returns an id add it to the user.
      user.update_attribute :infusion_id, contact[0]['Id'].to_i if contact[0]
    end
  end
end

# --- return from hold tasks ---

# def return_from_hold_notification
#   This method should send an email to parents who have a student who have left, but who have
#   a probable return date 14 days from now.
# end
