class AddWithholdingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :additional_withholding, :string
  end
end
