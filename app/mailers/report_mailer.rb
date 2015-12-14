class ReportMailer < ActionMailer::Base
  default from: "info@mathplusacademy.com"

  def monthly_student_report(student, parent)
    @student = student
    @parent = parent
    @todays_date = Date.today
    track user: @parent

    mail(to: @parent.email, subject: 'Your Monthly Student Report') if @parent
  end
end
