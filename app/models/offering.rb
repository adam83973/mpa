class Offering < ActiveRecord::Base
  attr_accessible :comments, :course_id, :day, :graduation_year, :location_id, :time, :user_id

  validates_presence_of :course_id, :day, :time, :location_id, :user_id

  belongs_to :location
  belongs_to :course
  belongs_to :user
  has_and_belongs_to_many :students

  def offering_name
      course.course_name + " | " + location.name + " | " + day + " - " + time.strftime("%I:%M %p")
  end

  def import
    Offering.import(params[:file])
    redirect_to offerings_path, notice: "Locations imported."
  end
end
