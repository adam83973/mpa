class AddSubdomainToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :subdomain, :string
    add_column :avatars, :subdomain, :string
    add_column :badges, :subdomain, :string
    add_column :experiences, :subdomain, :string
    add_column :occupation_levels, :subdomain, :string
  end
end
