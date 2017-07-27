class AddSubdomainToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :subdomain, :string
  end
end
