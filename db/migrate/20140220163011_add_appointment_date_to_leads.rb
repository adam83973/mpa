class AddAppointmentDateToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :appointment_date, :date
  end
end
