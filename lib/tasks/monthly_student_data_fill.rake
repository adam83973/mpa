namespace :db do
  desc "Refresh student data so it has current dates to test system."
  task refresh_student: :environment do
    if Rails.env.development?
      clear_student_record
      add_attendance
      add_homework_scores
      add_badge_requests
    end
  end
end

def clear_student_record
  student = set_student

  student.experience_points.destroy_all
  student.badge_requests.destroy_all
end

def add_attendance
  # Find student
  student = set_student
  beginning_of_month = Date.today.beginning_of_month
  attendance_experience = Experience.find 58

  4.times do |n|
    xp = ExperiencePoint.create!(experience_id:            attendance_experience.id,
                                 created_at:               beginning_of_month + (n*7).days,
                                 updated_at:                beginning_of_month + (n*7).days,
                                 user_id:                  User.system_admin_id,
                                 student_id:               student.id,
                                 points:                   attendance_experience.points,
                                 comment:                  "Week #{n+1} attendance. Thanks for attending!")
  end
end

def add_homework_scores
  student = set_student
  beginning_of_month = Date.today.beginning_of_month
  #load all homework achievements, perfect, complete and incomplete
  homework_achievements = Experience.where("occupation_id = ? AND name LIKE ?", 1, "%Homework%")
  homework_comments = ["Great job working the through the assignment and awesome participation in class. You did not miss a question. Quinn can focus harder on asking questions.", "There are a couple problems that still need some work. Nice work thus far! Awesome job in class.", "Please complete this week's assignment for credit. Homework help might be a good option to catch up on the missed work. If you need help scheduling homework help please let the Center Director know."]

  4.times do |n|
    random_homework_achievement = homework_achievements[[*0..2].sample]
    comment = set_homework_comment(homework_comments, random_homework_achievement)

    ExperiencePoint.create!(experience_id:            random_homework_achievement.id,
                            created_at:               beginning_of_month + (n*7).days,
                            updated_at:               beginning_of_month + (n*7).days,
                            user_id:                  User.system_admin_id,
                            student_id:               student.id,
                            points:                   random_homework_achievement.points,
                            comment:                  comment)
  end
end

def add_badge_requests
  student = set_student
  beginning_of_month = Date.today.beginning_of_month
  badges = Badge.all

  8.times do |n|
    badge = badges.sample
    BadgeRequest.create!(badge_id:                    badge.id,
                         student_id:                  student.id,
                         parent_submission:           false,
                         approved:                    true,
                         user_id:                     User.system_admin_id,
                         created_at:                  beginning_of_month + (n*7).days,
                         updated_at:                  beginning_of_month + (n*7).days,
                         date_approved:               beginning_of_month + (n*7).days,
                         write_up:                    "Sample write up here ;)")
  end
end

private

  def set_student
    Student.find 69
  end

  def set_homework_comment(comments, homework_achievement)
    case homework_achievement.id

    when 1
      comments[1]
    when 4
      comments[2]
    when 5
      comments[0]
    else
      "Something is wrong with how the comments are set..."
    end
  end
