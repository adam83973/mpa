class Student < ActiveRecord::Base
  attr_accessible :birth_date, :first_name, :last_name, :offering_ids, :user_id, :start_date
  has_and_belongs_to_many :offerings
  belongs_to :user
  belongs_to :location
  has_many :grades
  has_many :lessons , :through => :grades
  has_many :experiences, :through => :experience_points
  has_many :experience_points
  accepts_nested_attributes_for :experience_points

  def full_name
      first_name + " " + last_name
  end
end