namespace :send do
  desc "Tag active users infusionsoft accounts with month day year active tag."
  task notifications: :environment do
    trial_reminders
    restart_reminders
  end
end

def trial_reminders
  # pull opportunities that have trial dates for the following day
  opportunities_with_trials_tomorrow = Opportunity.where(trial_date: Date.tomorrow)

  opportunities_with_trials_tomorrow.each do |opportunity|
    NotificationMailer.trial_reminder(opportunity).deliver
  end
end

def first_class_reminders
  # pull opportunities that have trial dates for the following day
  registrations_starting_tomorrow = Registration.where(start_date: Date.tomorrow)

  registrations_starting_tomorrow.each do |registration|
    NotificationMailer.first_class_reminder(registration).deliver
  end
end

def restart_reminders
  registrations_restarting_in_a_week = Registration.where(restart_date: Date.today + 7.days)

  registrations_restarting_in_a_week.each do |regsitration|
    NotificationMailer.class_restarting_reminder(registration).deliver
  end
end
