class Noting < ActiveRecord::Base
  belongs_to :note
  belongs_to :noteable, polymorphic: true
end
