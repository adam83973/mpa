namespace :schedule do
  desc "These are for daily tasks that run at certain hours of the day."
  task hourly_tasks: :environment do
    hourly_tasks
  end
end

def hourly_tasks
  #load all companies
  companies = Company.all

  # Run various tasks for each company. All actions within a given task should be
  # will be run at the same time. Time is scoped via the company's timezone attribute.
  companies.each do |company|
    # Run daily tasks via scope of company
    case company.scope_time_zone{ Time.zone.now.hour }
    when 2 #early morning tasks
      # - operations:maintenance (hour 2)
      company.scope_schema { company.scope_time_zone{ Rake::Task['operations:maintenance'].execute } }
    when 20 # early evening tasks
      # - send:notifications (hour 21)
      company.scope_schema { company.scope_time_zone{ Rake::Task['notifications:send'].execute } }
    when 23 # late evening tasks
      # - location:daily_report (hour 23)
      company.scope_schema { Rake::Task['location:daily_report'].execute } if company.id == 1
    end
end


  # Run weekly tasks
  # -operations:reports (on sundays hour17)
end
