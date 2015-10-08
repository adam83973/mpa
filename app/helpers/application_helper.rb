module ApplicationHelper

	def flash_class(type)
		case type
		when :alert
			"danger"
		when :notice
			"success"
		else
			""
		end
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
