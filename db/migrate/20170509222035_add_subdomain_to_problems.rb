class AddSubdomainToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :subdomain, :string
  end
end
