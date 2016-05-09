class Noting < ActiveRecord::Base
  #attr_accessible :note_id, :noteable_id, :noteable_type
  belongs_to :note
  belongs_to :noteable, polymorphic: true
end
