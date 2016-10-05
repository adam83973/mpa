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
    @date = Date.today - 7.days
    @lessons_with_errors = Lesson.where(contains_error: true)
    @assignments = Assignment.where("created_at > ?", @date)

    mail(to: user.email, subject: "#{@date.strftime('%m/%d/%Y')} - Weekly Assignments Report") do |format|
      format.text
    end
  end

  def weekly_opportunities_report
    @date = (Date.today - 7.days)
    @opportunities_this_week = Opportunity.order(:location_id).where("created_at > ?", @date)
    @opportunities_last_30 = Opportunity.where("created_at >= ?", Date.today - 30.days)

    mail(to: user.email, subject: "#{@date.strftime('%m/%d/%Y')} - Weekly Opportunities Report") do |format|
      format.text
    end
  end
end

Opportunity.where("created_at <= ? AND created_at >= ?", (Date.today - 1.year).end_of_year, (Date.today - 1.year).beginning_of_year)

Opportunity.where("created_at <= ? AND created_at >= ?", (Date.today - 1.year).end_of_year, (Date.today - 1.year).beginning_of_year).where(status: 7).count

Opportunity.where("created_at <= ? AND created_at >= ?", (Date.today - 1.year).end_of_year, (Date.today - 1.year).beginning_of_year).where(status: 8).count
