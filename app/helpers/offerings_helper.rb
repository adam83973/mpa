module OfferingsHelper
  def offering_capacity(offering)
    if offering.at_capacity?
      "<span class='label label-important pull-right'>Full</span>"
    else
      "<span class='label label-success pull-right'>Open</span>"
    end
  end
end
