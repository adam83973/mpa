class Issue < ActiveRecord::Base
  #attr_accessible :name, :priority, :resolved, :status, :summary, :user_id

  belongs_to :user

  validates_presence_of :name, :summary, :status, :user_id

  PRIORITY_LEVELS = %w(Low Medium High)
  STATUS_LEVELS = %w(New Acknowledged Confirmed Assigned Closed)
end
