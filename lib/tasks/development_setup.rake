namespace :development do
  desc "Setup development environment"
  task setup: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:schema:load'].execute

    Company.skip_callback(:create, :after, :build_application_defaults)

    company = Company.create!(name:                                   'JMR Mathematics',
                              subdomain:                              'columbus',
                              time_zone:                              'Eastern Time (US & Canada)',
                              infusionsoft_integration:               true,
                              check_appointments_integration:         true,
                              check_appointments_assessment_id:       37117,
                              check_appointments_homework_help_id:    37118)
    puts "Seeding #{company.name} information."
    company.scope_schema { Rake::Task['development:seed'].execute subdomain: company.subdomain }

    company = Company.create!(name:                                   'ScoreGetter',
                              subdomain:                              'india',
                              time_zone:                              'Chennai',
                              check_appointments_integration:         true,
                              check_appointments_assessment_id:       113286,
                              check_appointments_homework_help_id:    nil)
    puts "Seeding #{company.name} information."
    company.scope_schema { Rake::Task['development:seed'].execute subdomain: company.subdomain }

    Company.set_callback(:create, :after, :build_application_defaults)
  end
end
