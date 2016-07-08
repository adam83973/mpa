namespace :send do
  desc "Tag active users infusionsoft accounts with month day year active tag."
  task notifications: :environment do
    trial_reminders
    restart_reminders
    # parent_login_reminder
  end
end

def first_class_reminders
  # pull opportunities that have trial dates for the following day
  registrations_starting_tomorrow = Registration.where(start_date: Date.tomorrow)

  registrations_starting_tomorrow.each do |registration|
    NotificationMailer.first_class_reminder(registration).deliver
  end
end

#if parents haven't logged in in the last 30 days, send reminder
def parent_login_reminder
  parents_no_log_in_last_30 = User.where(active: true, role: "Parent").where("current_sign_in_at < ? AND created_at > ?", Date.today - 30.days, Date.today + 30.days).where(first_email_reminder: false)
  parent_no_log_in_ever = User.where(active: true, role: "Parent", current_sign_in_at: nil).where(first_email_reminder: false)

  parents = parents_no_log_in_last_30.to_a + parent_no_log_in_ever.to_a

  parents.each do |parent|
    if NotificationMailer.parent_login_reminder(parent).deliver
      parent.update_attribute :first_email_reminder, true
    end
  end
end

def restart_reminders
  registrations_restarting_in_a_week = Registration.where(restart_date: Date.today + 7.days)

  registrations_restarting_in_a_week.each do |registration|
    NotificationMailer.class_restarting_reminder(registration).deliver
  end
end

def trial_reminders
  # pull opportunities that have trial dates for the following day
  opportunities_with_trials_tomorrow = Opportunity.where(trial_date: Date.tomorrow)

  opportunities_with_trials_tomorrow.each do |opportunity|
    NotificationMailer.trial_reminder(opportunity).deliver
  end
end
