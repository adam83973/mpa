class HelpSessionRecord < ActiveRecord::Base
  belongs_to :student
  belongs_to :user

  validates_presence_of :student_id, :comments, :user_id, :date, :session_length
end
