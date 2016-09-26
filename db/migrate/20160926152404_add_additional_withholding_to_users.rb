class AddAdditionalWithholdingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :addition_withholding, :string
  end
end
