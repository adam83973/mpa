desc "Ensures that resources uploaded as assignments and keys are match with the appropriate lesson."
  task assignment_to_lesson: :environment do
    assignment_to_lesson
  end


def assignment_to_lesson
  assignments = Resource.where("category = ?", "Assignments")
  assignment_keys = Resource.where("category = ?", "Assignment Keys")
  lessons = Lesson.all
  lesson_regex = /(?<course>\w+.\w+)\s(?<week>[0-9]|[1-9][0-9])\s-{1}\s(?<lesson>\b\w*)/
  key_regex = /(?<course>\w+.\w+).(?<week>[0-9]|[1-9][0-9])\s-{1}\s(?<lesson>\b\w*).*(?<key>\bKEY\b)/

  #Matches assignment key with lesson and adds resource id to lesson.assignemnt if it hasn't already
  #been added
  assignment_keys.each do |i|
    l = key_regex.match(i.filename)
    if l
      lessons_k = Lesson.where("week = ?", "#{l[:week]}")
      lessons_k.each do |lesson|
        if lesson.standard.course.course_name == l[:course]
          puts "#{lesson.name} #{l[:course]}, #{l[:week]} #{i.id}"
          lesson.assignment_key ||= i.id
          lesson.save
        end
      end
    end
  end

  #Matches assignment with lesson and adds resource id to lesson.assignemnt_key if it hasn't already
  #been added
  assignments.each do |i|
    r = lesson_regex.match(i.filename)
    if r
      lessons_a = Lesson.where("week = ?", "#{r[:week]}")
      lessons_a.each do |lesson|
        if lesson.standard.course.course_name == r[:course]
          puts "#{lesson.name} #{r[:course]}, #{r[:week]} #{i.id}"
          lesson.assignment ||= i.id
          lesson.save
        end
      end
    end
  end
end