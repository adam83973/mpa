namespace :email do
  desc "Update parent's record with various information from Infusionsoft."
  task offering_parents: :environment do
    email_offering_parents
  end
end

def email_offering_parents
  offerings = Offering.where("course_id = ? OR course_id = ? AND active = ?", 6, 7, true)
  active_parents_emails = []

  offerings.each do |offering|
    active_registrations = offering.registrations.where(status: 1)
    active_registrations.each do |registration|
      if registration.student && registration.student.user
        active_parents_emails << registration.student.user.email
      end
    end
  end
  puts active_parents_emails.count
  puts active_parents_emails.join(",")
end
