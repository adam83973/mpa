class AddTitleToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :title, :string
  end
end
