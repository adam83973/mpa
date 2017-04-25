class AddInfusionsoftIntegrationToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :infusionsoft_integration, :boolean, default: false
  end
end
