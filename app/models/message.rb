class Message < ActiveRecord::Base
  attr_accessible :content, :important, :read, :recipient_id, :subject, :user_id
end
