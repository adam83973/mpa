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

	def payment_status(paystatus, refundstatus)
		if paystatus == 0
      "<span class='badge badge-danger'>Unpaid</span>"
    elsif refundstatus == 1
      "<span class='badge badge-warning'>Partial Refund</span>"
    elsif refundstatus == 2
      "<span class='badge badge-warning'>Full Refund</span>"
    else
      "<span class='badge badge-success'>Paid</span>"
    end
	end
end
