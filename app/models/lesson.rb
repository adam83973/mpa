class Lesson < ActiveRecord::Base
  attr_accessible :assessment, :assessment_key, :assignment, :assignment_key, :standard_id, :name, :week

  belongs_to :standard 
  has_many :grades


  def title
  	if standard
      standard.course.course_name + "-" + week.to_s + ": " + name
    else
      week.to_s + ": " + name
  	end
  end

end
