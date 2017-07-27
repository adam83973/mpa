# # exclude Saturday classes, Math Teams, Robotics, Programming
# offerings = Offering.where("course_id < ? AND day != ? and Active = ?", 9, "Saturday", true)

# offerings.each do |offering|
#   offering.update_attribute :course_id, offering.course_id + 1
# end

# o.update_attribute :course_id, o.course_id + 1

# powell_reports = DailyLocationReport.where(location_id: 2)
#
# powell_reports.each {|report| puts "#{report.created_at.strftime("%b, %y")} - #{report.total_enrollment}"}
