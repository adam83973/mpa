class Message < ActiveRecord::Base
  attr_accessible :content, :important, :read, :recipient_id, :subject, :user_id, :general, :location_id

  belongs_to :user
  belongs_to :location
end
