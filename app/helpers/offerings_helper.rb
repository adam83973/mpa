module OfferingsHelper
  def offering_capacity(offering)
    if offering.at_capacity?
      "<span class='label label-important pull-right'>Full</span>"
    else
      "<span class='label label-success pull-right'>Open</span>"
    end
  end

  def offering_name_lookup(id)
    if id
      Offering.find(id).offering_name
    else
      nil
    end
  end

  def schedule_by_classroom(cr, offerings)
    schedule = []
    schedule << "<ul>"
      offerings.each do |offering|
        if offering.day == Time.now.strftime('%A') && offering.classroom == cr
          schedule << "<li> #{offering.offering_name} </li>"
          schedule << "<ul>"
          offering.users.each do |teacher|
            if teacher.active?
              schedule << "<li><em>#{teacher.full_name}</em></li>"
            end
          end
          schedule << "</ul>"
        end
      end
    schedule << "</ul>"
    schedule.join
  end

  def roster_count(offering)
    offering.students.active.count + offering.students.restarting.count + offering.students.future_adds.count
  end

  def open_spots(offering)
    if offering.course_id < 10
      10 - (roster_count(offering))
    elsif [10].include?(offering.course_id)
      14 - (roster_count(offering))
    elsif [11, 12].include?(offering.course_id)
      8 - (roster_count(offering))
    elsif [13, 17].include?(offering.course_id)
      10 - (roster_count(offering))
    elsif [15, 16, 18].include?(offering.course_id)
      8 - (roster_count(offering))
    end
  end
end
