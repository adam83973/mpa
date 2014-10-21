module OpportunitiesHelper
  def opportunity_status(opp)
    case opp.status
    when 0
      "<span class='label label-warning'>Interested</span>"
    when 1
      "<span class='label label-purple'>Appointment Scheduled</span>"
    when 2
      "<span class='label label-danger'>Appointment Missed</span>"
    when 3
      "<span class='label label-yellow'>Trial</span>"
    when 4
      "<span class='label label-default'>Undecided</span>"
    when 5
      "<span class='label label-blue'>Waitlisted</span>"
    when 6
      "<span class='label label-brown'>Possible Restart</span>"
    when 7
      "<span class='label label-success'>Possible Restart</span>"
    when 8
      "<span class='label label-danger'>Possible Restart</span>"
    end
  end
end
