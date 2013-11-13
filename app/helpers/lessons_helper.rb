module LessonsHelper
  def resource_lookup(id)
    Resource.find(id)
  end
end
