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
    track user: @parent unless @parent.id == 1 || Rails.env.development?

    mail(to: @parent.email, subject: 'Your Monthly Student Report')
  end

  def monthly_student_report_preview(student, parent, month, year)
    company = Company.find_by_subdomain(parent.subdomain)
    company.scope_schema do
      monthly_student_report(student, parent, month, year)
    end
  end

  def weekly_assignments_report(user)
    @date = Date.today - 7.days
    @lessons_with_errors = Lesson.where(contains_error: true)
    @assignments = Assignment.where("created_at > ?", @date)

    mail(to: user.email, subject: "#{@date.strftime('%m/%d/%Y')} - Weekly Assignments Report") do |format|
      format.text
    end
  end

  def weekly_opportunities_report(user)
    @date = (Date.today - 7.days)
    @opportunities_this_week = Opportunity.order(:location_id).where("created_at > ?", @date)
    @opportunities_last_30 = Opportunity.where("created_at >= ?", Date.today - 30.days)
    @opportunities_ytd = Opportunity.where("created_at >= ?", Date.today.beginning_of_year)

    mail(to: user.email, subject: "#{@date.strftime('%m/%d/%Y')} - Weekly Opportunities Report") do |format|
      format.text
    end
  end
end
