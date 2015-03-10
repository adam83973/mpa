class BadgesStudent < ActiveRecord::Base
  attr_accessible :badge_id, :student_id

  # join table. Table name: offerings_students

  belongs_to :student
  belongs_to :offering
end