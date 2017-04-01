namespace :development do
  desc "Setup development environment"
  task setup: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:schema:load'].execute

    company = Company.create!(name: 'JMR Mathematics', subdomain: 'columbus')
    puts "Seeding #{company.name} information."
    company.scope_schema { Rake::Task['development:seed'].invoke }

    company = Company.create!(name: 'ScoreGetter', subdomain: 'india')
    puts "Seeding #{company.name} information."
    company.scope_schema { Rake::Task['new:company'].invoke }

  end
end

# db_tasks.each do |task_name|
#   Rake::Task[task_name].enhance(["multitenant:#{task_name}"])
# end
#
# db_tasks.each do |task_name|
#   desc "Run #{task_name} for each tenant"
#   task task_name => %w[environment db:load_config] do
#     Tenant.find_each do |tenant|
#       puts "Running #{task_name} for tenant#{tenant.id} (#{tenant.subdomain})"
#       tenant.scope_schema { Rake::Task[task_name].execute }
#     end
#   end
# end
