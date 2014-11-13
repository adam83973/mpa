class BadgeObserver < ActiveRecord::Observer
  observe :experience_point

  def after_create(xp)
    student = Student.find(xp.student_id)
    student.update_attribute :status, "Badge!"
  end
end