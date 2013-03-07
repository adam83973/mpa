class Student < ActiveRecord::Base
  attr_accessible :birth_date, :first_name, :last_name, :offering_id, :user_id, :start_date
  belongs_to :offering
  belongs_to :user
  belongs_to :location

  def full_name
      first_name + " " + last_name
  end
end
