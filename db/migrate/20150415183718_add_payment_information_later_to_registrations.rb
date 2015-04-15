class AddPaymentInformationLaterToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :payment_information_later, :boolean
  end
end
