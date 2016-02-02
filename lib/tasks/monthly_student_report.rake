namespace :send do
  desc "Refresh student data so it has current dates to test system."
  task monthly_student_reports: :environment do
    send_student_reports
  end
end

def send_student_reports
  active_last_month = load_parents_with_students_who_attended_last_month

  month = (Date.today - 1.month).month.to_i
  year = (Date.today - 1.month).year

  active_last_month.each do |parent|
    parent.students.each do |student|
      if student.attendance_last_month.any?
        ReportMailer.monthly_student_report(student, parent, month, year).deliver
      end
    end
  end
end

def load_parents_with_students_who_attended_last_month
  parents = User.where(role: 'Parent').includes(:students)
  active_last_month = []

  parents.each_with_index do |parent, i|
    parent.students.each do |student|
      active_last_month << parent if student.attendance_last_month.any?
    end
  end

  active_last_month
end
