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
end
