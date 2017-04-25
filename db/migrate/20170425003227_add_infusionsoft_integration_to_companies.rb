class AddInfusionsoftIntegrationToCompanies < ActiveRecord::Migration[5.0]
  def change
    if ActiveRecord::Base.connection.tables.include?('companies')
      add_column :companies, :infusionsoft_integration, :boolean, default: false
    end
  end
end
