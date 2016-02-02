class ReportMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "info@mathplusacademy.com"

  def monthly_student_report(student, parent, month, year)
    @date = Date.parse("#{month}/#{year}")
    @student = student
    @parent = parent
    @assignments = student.assignments_last_month
    @todays_date = Date.today
    track user: @parent

    mail(to: @parent.email, subject: 'Your Monthly Student Report') if @parent
  end
end
