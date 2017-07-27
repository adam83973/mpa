class EditDefaultsRegistration < ActiveRecord::Migration
  def change
    change_column :registrations, :status, :integer, :default => 0
  end
end
