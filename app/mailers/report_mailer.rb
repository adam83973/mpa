class ReportMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "info@mathplusacademy.com"

  def monthly_student_report(student, parent, month, year)
    @date = Date.parse("#{month}/#{year}")
    @student = student
    @parent = parent
    @assignments = student.assignments_last_month.order(:course_id, :week)
    @hw_help_sessions = student.help_sessions_last_month.order(:date)
    @active_math_classes = student.active_math_classes
    @todays_date = Date.today
    track user: @parent unless @parent.id == 1

    mail(to: @parent.email, subject: 'Your Monthly Student Report') if @parent && @active_math_classes.any?
  end

  def weekly_assignments_report(user)
    @lessons_with_errors = Lesson.where(contains_error: true)
    @assignments = Assignment.where("created_at > ?", Date.today - 7.days)
    @date = (Date.today - 7.days).strftime('%m/%d/%Y')
    mail(to: user.email, subject: "#{@date} - Weekly Assignments Report") do |format|
      format.text
    end
  end
end
