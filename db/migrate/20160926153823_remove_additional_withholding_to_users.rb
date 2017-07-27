class RemoveAdditionalWithholdingToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :addition_withholding, :string
  end
end
