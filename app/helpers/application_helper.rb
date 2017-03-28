module ApplicationHelper

	def bootstrap_class_for flash_type
	{ success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym]
	end

	def flash_messages(opts = {})
		flash.each do |msg_type, message|
			concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade show") do
							concat content_tag(:button, "&times".html_safe, class: "close", data: { dismiss: 'alert' })
							concat message
						end)
		end
		nil
	end

	def title(page_title)
		content_for(:title) { page_title }
	end

	def pluralize_without_count(count, noun, text = nil)
	  if count != 0
	    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
	  end
	end

	def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

	def assignment_status(assignment)
	  case assignment.score
	  when 1
			'<span style="color: green; font-family: "Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif; margin: 0; padding: 0;">Complete</span>'.html_safe
		when 0
			'<span style="color: red; font-family: "Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif; margin: 0; padding: 0;">Incomplete</span>'.html_safe
		when 2
			'<span style="color: blue; font-family: "Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif; margin: 0; padding: 0;">Perfect</span>'.html_safe
	  end
	end
end

def unsimple_format(text)
  text.gsub(/\r\n?/, "\n").split(%r{(\n*(?:<h4>.*?</h4>|<blockquote(?: .*?)?>.*?</blockquote>)\n*)}im).map do |part|
    case part
    when /\A\s*\Z/, /<h4>/
      part
    when /blockquote/
      part.sub(%r{(<blockquote(?: .*?)?>)(.*?)(</blockquote>)}im) { $1 + simple_format($2) + $3 }
    else
      simple_format(part)
    end
  end.join
end

def simple_format_no_tags(text, html_options = {}, options = {})
  text = '' if text.nil?
  text = smart_truncate(text, options[:truncate]) if options[:truncate].present?
  text = sanitize(text) unless options[:sanitize] == false
  text = text.to_str
  text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
  text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
  text.html_safe
end
