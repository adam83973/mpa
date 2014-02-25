class Lead < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :stage_id, :student_information, :user_id, :active, :location_id, :appointment_date

  belongs_to :user
  belongs_to :location
  belongs_to :stage

  has_many  :notes, as: :notable

  def full_name
    first_name + " " + last_name
  end

  def update_stage(id)
    update_column(:stage_id, id.to_i)
  end

  def self.active_stage_count(stage_name, location_id)
    self.where('stage_id = ? AND active = ? AND location_id = ?', Stage.where('name = ?', stage_name), true, location_id).count
  end
end
