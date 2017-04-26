# rake tasks specific to JMR Mathematics
daily_tasks = %w[infusionsoft:daily_maintenance]

namespace :jmr_mathematics do
  desc "Run daily tasks specific to JMR Mathematics"
  task :daily_tasks => %w[environment db:load_config] do
    company = Company.find 1
    daily_tasks.each do |daily_task|
      puts "Running #{daily_task} for company#{company.id} (#{company.subdomain})"
      company.scope_schema { Rake::Task[daily_task].execute }
    end
  end
end
