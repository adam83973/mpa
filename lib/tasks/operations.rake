namespace :operations do
  desc "Perform various maintenance tasks."
  task maintenance: :environment do
    end_date
    deactivate_parents
  end
end

def end_date
  #pull all students with end date equal to curent day's date
  students = Student.where("end_date = ?", Date.today)

  #cycle through students and set status to inactive if student has end date for current day
  students.each do |student|
    if student.end_date == Date.today && student.status = "Active"
      #set status to inactive
      student.update_attribute :status, "Inactive"
    end
  end
end

def deactivate_parents
  parents = User.where("role = ? AND active = ?", "Parent", true)
  parents.each do |p|
    unless p.active_students?
      p.update_attribute :active, false
      Infusionsoft.contact_add_to_group(p.infusion_id, 1648)
    end
  end
end
