class AddCheckAppointmentsReasonIdsToCompanies < ActiveRecord::Migration[5.0]
  def change
    if ActiveRecord::Base.connection.tables.include?('companies')
      add_column :companies, :check_appointments_assessment_id, :integer
      add_column :companies, :check_appointments_homework_help_id, :integer
    end
  end
end
