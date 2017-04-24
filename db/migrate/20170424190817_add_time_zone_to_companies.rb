class AddTimeZoneToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :time_zone, :string
  end
end
