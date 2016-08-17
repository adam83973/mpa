module AttendancesHelper
  def last_attendance_date(attendance)
    date = attendance
    if date > Date.today - 14.days == true
      "<span style='color:green;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
    elsif date <= Date.today - 14.days && date >= Date.today - 30.days == true
      "<span style='color:orange;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
    elsif date < Date.today - 30.days == true
      "<span style='color:red;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
    end
  end
end
