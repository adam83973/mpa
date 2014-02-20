class Note < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :content, :due, :due_date, :lead_id, :user_id

  belongs_to :notable, polymorphic: true
  belongs_to :user
end
