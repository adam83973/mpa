module InfusionPagesHelper
		def cc_status (status)
		if status == 0
			"Unknown"
		elsif status == 1
			"Invalid"
		elsif status == 2
			"Deleted"
		elsif status == 3
			"Valid"
		elsif status == 4
			"Inactive"
		else
			status
		end
	end

	def exp_date (month, year)
		if month && year
			month+"/"+year.last(2)
		else
			"none"
		end
	end
end
