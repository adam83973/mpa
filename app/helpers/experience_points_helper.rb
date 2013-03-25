module ExperiencePointsHelper
	def get_students_name
  		Student.pluck("first_name, last_name")    
	end
end
