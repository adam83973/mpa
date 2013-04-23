class Student < ActiveRecord::Base
  attr_accessible :birth_date, :first_name, :last_name, :offering_ids, :user_id, :start_date, :xp_total, :credits
  belongs_to :user
  belongs_to :location
  has_many :grades
  has_many :lessons , :through => :grades
  has_many :experiences, :through => :experience_points
  has_many :experience_points
  has_and_belongs_to_many :offerings

  def full_name
      first_name + " " + last_name
  end

  def parent_name
      user.first_name + " " + user.last_name
  end

  def xp_sum
    experience_points.sum(:points)
  end

  def calculate_xp
    update_column(:xp_total, xp_sum)
  end

  def calculate_credit(experience_point)
    ((xp_sum + experience_point.points)/100 - ((xp_sum)/100))    
  end  

  def add_credit(newcredit)
    if self.credits
      increment!(:credits,  newcredit)
    end
  end
end