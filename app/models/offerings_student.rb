class OfferingsStudent < ActiveRecord::Base
  attr_accessible :offering_id, :student_id

  # join table. Table name: offerings_students

  belongs_to :student
  belongs_to :offering

end