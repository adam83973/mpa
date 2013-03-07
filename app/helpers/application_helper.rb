module ApplicationHelper
	def flash_class(type)
		case type
		when :alert
			"alert-error"
		when :notice
			"alert-success"
		else
			""
		end
	end

	def title(page_title)
		content_for(:title) { page_title }
	end
end
