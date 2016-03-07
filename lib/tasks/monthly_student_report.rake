namespace :send do
  desc "Refresh student data so it has current dates to test system."
  task monthly_student_reports: :environment do
    send_student_reports
  end
  task test_student_report: :environment do
    send_test_report
  end
end

def send_student_reports
  active_last_month = load_parents_with_students_who_attended_last_month
  sent_reports = [1367,1368,1403,660,1401,1397,1051,1411,1430,1432,1427,171,171,1419,1440,1456,209,209,209,209,1465,1462,1464,1444,1464,1439,842,416,1393,88,1422,1313,1382,1424,1316,448,1439,1367,605,605,196,177,369,369,599,1354,284,1182,1315,415,1415,1329,1364,1442]


  month = (Date.today - 1.month).month.to_i
  year = (Date.today - 1.month).year
  count = 0
  active_last_month.each do |parent|
    parent.students.each do |student|
      if student.attendance_last_month.any?
        unless sent_reports.include?(parent.id.to_i)
          ReportMailer.monthly_student_report(student, parent, month, year).deliver
          count += 1
        end
      end
    end
  end

  count
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
      active_last_month << parent if student.attendance_last_month.any?
    end
  end

  active_last_month = active_last_month.uniq
end
