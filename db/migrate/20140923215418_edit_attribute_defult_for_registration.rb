class EditAttributeDefultForRegistration < ActiveRecord::Migration
  def change
    change_column :registrations, :attended_first_class, :boolean, :default => false
    change_column :registrations, :attended_trial, :boolean, :default => false
    change_column :registrations, :status, :integer, :default => 1
  end
end
