class AddNewPostToAppointmentRequest < ActiveRecord::Migration
  def change
    add_column :appointment_requests, :new_post, :boolean, default: false
  end
end
