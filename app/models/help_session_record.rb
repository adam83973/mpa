class HelpSessionRecord < ActiveRecord::Base
  belongs_to :student

  validates_presence_of :student_id, :comments, :user_id
end
