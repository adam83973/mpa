class Note < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :opportunity
  belongs_to :location
  belongs_to :notable, polymorphic: true
  belongs_to :user, foreign_key: "user_id"

  def not_nameable
    # unable to reference full_name for these notes
    notable.class.name == "Opportunity" || notable.class.name == "Lesson" || !(notable)
  end
end
