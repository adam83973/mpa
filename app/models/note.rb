class Note < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :content, :action_date, :completed, :user_id

  belongs_to :location
  belongs_to :notable, polymorphic: true
  belongs_to :user, foreign_key: "user_id"
end
