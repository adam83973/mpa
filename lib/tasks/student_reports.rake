namespace :student_reports do
  desc "Refresh student data so it has current dates to test system."
  task send_monthly_report: :environment do
    send_student_reports
  end
  task send_test_report: :environment do
    send_test_report
  end
end

def send_student_reports
  companies_with_student_reporting = Company.where(send_student_reports: true)
  # Pull companies that have monthly student reporting

  companies_with_student_reporting.each do |company|
    company.scope_schema do
      active_last_month = load_parents_with_students_who_attended_last_month

      month = (Date.today - 1.month).month.to_i
      year = (Date.today - 1.month).year
      count = 0
      reports_not_sent = []
      active_last_month.each do |parent|
        parent.students.each do |student|
          if student.attendances_last_month.any?
            puts student.id
            ReportMailer.monthly_student_report(student, parent, month, year)
            count += 1
          end
        end
      end


      puts count.to_s + " Reports Sent"
      puts reports_not_sent
    end
  end
end

def send_test_report
  month = (Date.today - 1.month).month.to_i
  year = (Date.today - 1.month).year

  if Rails.env.development?
    student = Student.find 69
    parent = User.find 1
  else
    student = Student.find 88
    parent = User.find 1
  end

  ReportMailer.monthly_student_report(student, parent, month, year).deliver
end

def load_parents_with_students_who_attended_last_month
  parents = User.where(role: 'Parent').includes(:students)
  active_last_month = []

  parents.each_with_index do |parent, i|
    parent.students.each do |student|
      active_last_month << parent if student.attendances_last_month.any?
    end
  end

  active_last_month = active_last_month.uniq
end
