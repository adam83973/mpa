namespace :version do
  #Rake task runs at end of day.
  desc "Perform various maintenance tasks."
  task prepare: :environment do
    create_company
    flag_achievements
    prepare_students
    mark_system_administrator
  end
end
# The purpose of this task is to convert from version 1.x to version 2.x. This to be run after the database changes have been fully migrating.

# Create new company name: JMR Mathematics, subdomain: columbus
# Skip schema creation
def create_company
  Company.skip_callback(:create, :after, :create_schema)

  Company.create!(name: 'JMR Mathematics', subdomain: 'columbus', time_zone: 'Eastern Time (US & Canada)', infusionsoft_integration: true)

  Company.set_callback(:create, :after, :create_schema)
end

# Flag achievements with attendance/ assignment etc.
def flag_achievements
  math_attendance_experience = Experience.find 67
  programming_attendance_experience = Experience.find 69
  chess_attendance_experience = Experience.find 74

  math_attendance_experience.update_attributes         attendance: true, course_id: nil
  programming_attendance_experience.update_attributes  attendance: true, course_id: 15
  chess_attendance_experience.update_attributes        attendance: true, course_id: 10
end

def mark_system_administrator
  u = User.find 757
  u.update_attribute :system_administrator, true
end


# Student attributes
def prepare_students
  students = Student.all

  students.each do |student|
    #cache mathematician xp
    student.update_attribute :mathematician_experience_points, xp_sum_by_occupation("Mathematician", student)

    #cache engineer xp
    student.update_attribute :engineer_experience_points, xp_sum_by_occupation("Engineer", student)

    #cache programmer xp
    student.update_attribute :programmer_experience_points, xp_sum_by_occupation("Programmer", student)

    # recache occupation levels and total experience points
    student.update_attributes mathematician_level: student.math_level, engineer_level: student.eng_level, programmer_level: student.prog_level, experience_point_total: student.xp_total
  end
end

def xp_sum_by_occupation(category, student)
  total = 0
  student.experience_points.where("created_at > ?",  Student::RESET_DATE).includes(:experience, :occupation).each do |xp|
    if xp.occupation && xp.occupation.title == category
      total += xp.points
    end
  end
  total
end
