class Note < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  #attr_accessible :content, :action_date, :completed, :user_id, :location_id, :notable_type, :notable_id, :opportunity_id, :completed_by

  belongs_to :opportunity
  belongs_to :location
  belongs_to :notable, polymorphic: true
  belongs_to :user, foreign_key: "user_id"

  def not_nameable
    # unable to reference full_name for these notes
    notable.class.name == "Opportunity" || notable.class.name == "Lesson" || !(notable)
  end
end
