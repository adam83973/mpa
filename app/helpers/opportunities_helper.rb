module OpportunitiesHelper
  def opportunity_status(opp)
    case opp.status
    when 0
      "<span class='badge badge-warning'>Interested</span>"
    when 1
      "<span class='badge badge-purple'>Appointment Scheduled</span>"
    when 2
      "<span class='badge badge-danger'>Appointment Missed</span>"
    when 3
      "<span class='badge badge-yellow'>Trial</span>"
    when 4
      "<span class='badge badge-default'>Undecided</span>"
    when 5
      "<span class='badge badge-blue'>Waitlisted</span>"
    when 6
      "<span class='badge badge-brown'>Possible Restart</span>"
    when 7
      "<span class='badge badge-success'>Won</span>"
    when 8
      "<span class='badge badge-danger'>Lost</span>"
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

  #return list of changes.
  def opportunity_changes(version)
    content = "<ol> "
    version.changeset.delete_if{|k,v| k == 'updated_at'}.each do |attribute, changes|
      if changes[0] == nil && changes[1] == nil
      elsif changes[0] == nil
        if attribute == 'status'
          content = content + "<li>Status set to <span style='color:green;'>#{changes[1]}</span>.</li>"
        elsif attribute == 'course_id'
          content = content + "<li>Course set to <span style='color:green;'>#{Course.find(changes[1]).name}</span>.</li>"
        elsif attribute == 'offering_id'
          content = content + "<li>Offering set to <span style='color:green;'>#{Offering.find(changes[1]).offering_name}</span>.</li>"
        else
          content = content + "<li>#{attribute.gsub('_', ' ').split.map(&:capitalize).join(' ')} <span style='color:green;'>added</span>.</li>"
        end
      else
        if attribute == 'status'
          content = content + "<li>#{attribute.gsub('_', ' ').split.map(&:capitalize).join(' ')} changed from <span style='color:red;'>#{changes[0] ? Opportunity::STATUSES[changes[0]] : "nil" }</span> to <span style='color:green;'>#{changes[1] ? Opportunity::STATUSES[changes[1]] : "nil" }</span>.</li>"
        elsif attribute == 'course_id'
          content = content + "<li>Course changed from <span style='color:red;'>#{Course.find(changes[0]).name}</span> to <span style='color:green;'>#{Course.find(changes[1]).name}</span>.</li>"
        elsif attribute == 'offering_id'
          content = content + "<li>Offering changed from <span style='color:red;'>#{Offering.find(changes[0]).offering_name}</span> to <span style='color:green;'>#{Offering.find(changes[1]).offering_name}</span>.</li>"
        else
          content = content + "<li>#{attribute.gsub('_', ' ').split.map(&:capitalize).join(' ')} changed from <span style='color:red;'>#{changes[0]}</span> to <span style='color:green;'>#{changes[1]}</span>.</li>"
        end
      end
    end
    content = content + "</ol>"
  end
end
