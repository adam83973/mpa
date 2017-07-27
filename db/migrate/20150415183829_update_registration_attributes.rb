class UpdateRegistrationAttributes < ActiveRecord::Migration
  def change
    change_column :registrations, :payment_information_later, :boolean, :default => false
  end
end
