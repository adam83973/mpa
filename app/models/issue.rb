class Issue < ActiveRecord::Base
  attr_accessible :name, :priority, :resolved, :status, :summary, :user_id

  belongs_to :user
  
  PRIORITY_LEVELS = %w(Low Medium High)
  STATUS_LEVELS = %w(New Acknowledged Confirmed Assigned Resolved Closed)
end
