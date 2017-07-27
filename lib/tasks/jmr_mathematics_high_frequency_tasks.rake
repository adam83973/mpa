# rake tasks specific to JMR Mathematics
high_frequency_tasks = %w[check_inbox]

namespace :jmr_mathematics do
  desc "Run daily tasks specific to JMR Mathematics"
  task :high_frequency_tasks => %w[environment db:load_config] do
    company = Company.find 1
    high_frequency_tasks.each do |high_frequency_task|
      puts "Running #{high_frequency_task} for company#{company.id} (#{company.subdomain})"
      company.scope_schema { Rake::Task[high_frequency_task].execute }
    end
  end
end
