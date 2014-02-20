class Lead < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :stage_id, :student_information, :user_id

  belongs_to :user
  belongs_to :stage

  has_many  :notes, as: :notable

  def full_name
    first_name + " " + last_name
  end

  def update_stage(id)
    update_column(:stage_id, id.to_i)
  end
end
