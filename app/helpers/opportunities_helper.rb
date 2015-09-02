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
      "<span class='label label-success'>Won</span>"
    when 8
      "<span class='label label-danger'>Lost</span>"
    end
  end

  def opportunity_interest(opp)
    case opp.interest_level
    when 0
      '<i class="fa fa-fire pull-right"></i>'
    when 1
      '<i style="color:orange;" class="fa fa-fire pull-right"></i>'
    when 2
      '<i style="color:red;" class="fa fa-fire pull-right"></i>'
    else
      '<i class="fa fa-fire pull-right"></i>'
    end
  end
end
