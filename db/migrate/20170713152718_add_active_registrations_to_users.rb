class AddActiveRegistrationsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active_registration, :boolean, default: false
  end
end
