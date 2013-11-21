class Video < ActiveRecord::Base
  attr_accessible :lesson_id, :title, :url

  belongs_to :lesson
end
