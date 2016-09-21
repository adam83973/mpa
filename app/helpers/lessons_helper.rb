module LessonsHelper
  def resource_lookup(id)
    Resource.find(id) unless id == nil || id == ''
  end

  def lesson_status(lesson)
    if lesson.contains_error
      "<span class='label label-danger'>Needs Review</span>".html_safe
    else
      "<span class='label label-success'>OK</span>".html_safe
    end
  end
end
