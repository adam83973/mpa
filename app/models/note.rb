class Note < ActiveRecord::Base
  attr_accessible :content, :due, :due_date, :lead_id, :user_id
end
