class AddAttributesToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :appointment_date, :date
    add_column :opportunities, :parent_name, :string
    add_column :opportunities, :course_id, :integer
    add_column :opportunities, :location_id, :integer
    add_column :opportunities, :student_name, :string
    add_column :opportunities, :date_won, :date
    add_column :opportunities, :date_lost, :date
    add_column :opportunities, :source, :integer
  end
end
