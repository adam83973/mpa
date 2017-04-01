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
