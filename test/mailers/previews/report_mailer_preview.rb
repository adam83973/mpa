class ReportMailerPreview < ActionMailer::Preview
  # Accessible from /rails/mailers/report_mailer/monthly_student_report
  def monthly_student_report
    company = Company.find 1

    company.scope_schema do
      student = Student.find 1
      parent = student.user
      ReportMailer.monthly_student_report_preview(student, parent, "6", "2017")
    end
  end
end
