module AttendancesHelper
  def last_attendance_date(attendance)
    date = @last_attendance
    if date > Date.today - 14.days == true
      @last_attendance_date = "<span style='color:green;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
    elsif date <= Date.today - 14.days && date >= Date.today - 30.days == true
      @last_attendance_date = "<span style='color:orange;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
    elsif date < Date.today - 30.days == true
      @last_attendance_date = "<span style='color:red;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
    end
  end
end
