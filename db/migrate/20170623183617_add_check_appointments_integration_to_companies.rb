class AddCheckAppointmentsIntegrationToCompanies < ActiveRecord::Migration[5.0]
  def change 
    if ActiveRecord::Base.connection.tables.include?('companies')
      add_column :companies, :check_appointments_integration, :boolean, default: false
    end
  end
end
