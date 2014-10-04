class AddColumnsToOpportunitites < ActiveRecord::Migration
  def change
    add_column :opportunities, :parent_email, :string
    add_column :opportunities, :parent_phone, :string
    add_column :opportunities, :undecided_date, :date
  end
end
