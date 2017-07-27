class AddTimetapIntegrationToCompanies < ActiveRecord::Migration[5.0]
  def change
    if ActiveRecord::Base.connection.tables.include?('companies')
      add_column :companies, :timetap_integration, :boolean, default: false
    end
  end
end
