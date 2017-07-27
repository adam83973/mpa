class AddAttributesToCompanies < ActiveRecord::Migration[5.0]
  def change
    if ActiveRecord::Base.connection.tables.include?('companies')
      add_column :companies, :infusionsoft_integration, :boolean, default: false
      add_column :companies, :time_zone, :string
    end
  end
end
