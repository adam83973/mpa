module LessonsHelper
  def resource_lookup(id)
    Resource.find(id) unless id == nil
  end
end
