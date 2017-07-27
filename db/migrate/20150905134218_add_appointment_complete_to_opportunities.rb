class AddAppointmentCompleteToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :appointment_complete, :boolean, default: :false
  end
end
