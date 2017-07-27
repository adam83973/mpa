class AddConfirmationOptOutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_opt_out, :boolean, default: false
  end
end
