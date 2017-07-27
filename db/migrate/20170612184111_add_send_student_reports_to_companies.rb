class AddSendStudentReportsToCompanies < ActiveRecord::Migration[5.0]
  def change
    if ActiveRecord::Base.connection.tables.include?('companies')
      add_column :companies, :send_student_reports, :boolean, default: false
    end
  end
end
