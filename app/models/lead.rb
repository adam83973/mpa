class Lead < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :stage_id, :student_information, :user_id, :active

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

  def self.active_stage_count(stage_name, user_id)
    self.where('stage_id = ? AND user_id = ? AND active = ?', Stage.where('name = ?', stage_name), user_id, true).count
  end
end
