class Lead < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :stage_id, :student_information, :user_id

  belongs_to :user
  belongs_to :note
  belongs_to :stage

  def full_name
    first_name + " " + last_name
  end
end
