namespace :send do
  desc "Tag active users infusionsoft accounts with month day year active tag."
  task notifications: :environment do
    trial_reminders
  end
end

def trial_reminders
  # pull opportunities that have trial dates for the following day
  opportunities_with_trials_tomorrow = Opportunity.where(trial_date: Date.tomorrow)

  opportunities_with_trials_tomorrow.each do |opportunity|
    NotificationMailer.trial_reminder(opportunity).deliver
  end
end
