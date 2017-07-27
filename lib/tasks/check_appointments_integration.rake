desc "Prepare records for check appointments integration."
task check_appointments_integration: :environment do
  set_company_flags_and_update_locations
end

def set_company_flags_and_update_locations
  companies = Company.all

  companies.each do |company|
    # set company specific information for check appointments
    company.update_attribute :check_appointments_integration, true
    if company.subdomain == 'columbus'
      company.update_attributes check_appointments_assessment_id: 37117,
                                check_appointments_homework_help_id: 37118
    elsif company.subdomain == 'india'
      company.update_attributes check_appointments_assessment_id: 113286
    end
    # update each location per company
    company.scope_schema do
      if company.subdomain == 'columbus'
        Location.find(1).update_attribute :check_appointments_id, 10936
        Location.find(2).update_attribute :check_appointments_id, 23402
        Location.find(3).update_attribute :check_appointments_id, 10935
      elsif company.subdomain == 'india'
        Location.find(3).update_attribute :check_appointments_id, 44649
        Location.find(4).update_attribute :check_appointments_id, 44301
      end
    end
  end
end
