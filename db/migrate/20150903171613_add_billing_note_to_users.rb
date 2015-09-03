class AddBillingNoteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_note, :text, default: ""
  end
end
