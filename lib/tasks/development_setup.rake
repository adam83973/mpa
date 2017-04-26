namespace :development do
  desc "Setup development environment"
  task setup: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:schema:load'].execute

    company = Company.create!(name: 'JMR Mathematics', subdomain: 'columbus', time_zone: 'Eastern Time (US & Canada)', infusionsoft_integration: true)
    puts "Seeding #{company.name} information."
    company.scope_schema { Rake::Task['development:seed'].execute subdomain: company.subdomain }

    company = Company.create!(name: 'ScoreGetter', subdomain: 'india', time_zone: 'Chennai')
    puts "Seeding #{company.name} information."
    company.scope_schema { Rake::Task['development:seed'].execute subdomain: company.subdomain }
  end
end
