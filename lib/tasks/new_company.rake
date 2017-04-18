namespace :new do
  desc "Setup development environment"
  task company: :environment do

    company = Company.find 2
    puts "Seeding #{company.name} information."
    company.scope_schema { Rake::Task['development:seed'].execute subdomain: company.subdomain }

  end
end
