class Attendance < ActiveRecord::Base
  belongs_to :student, dependent: :destroy
  belongs_to :offering
  belongs_to :experience_point, dependent: :destroy

  after_create :add_experience_point

  PRODUCTION_ATTENDANCE_EXPERIENCE_ID = 1
  DEVELOPMENT_ATTENDANCE_EXPERIENCE_ID = 86
  COMMENTS = ["You made it to class!", "You're smarter because you came!", "Way to go! Here are some points for showing up :)", "You could have stayed home, but you decided to do brain pushups.", "The brain is strong in this one.", "See you next time!", "Thanks for coming!", "Great to see you. Here are some points."]

  def add_experience_point
    if Rails.env.development?
      attendance_experience_point = ExperiencePoint.create!(student_id: self.student_id, experience_id: DEVELOPMENT_ATTENDANCE_EXPERIENCE_ID, comment: COMMENTS[rand(0..(COMMENTS.count - 1))], points: 20 )
    elsif Rails.env.production?
      attendance_experience_point = ExperiencePoint.create!(student_id: self.student_id, experience_id: PRODUCTION_ATTENDANCE_EXPERIENCE_ID, comment: COMMENTS[rand(0..(COMMENTS.count - 1))], points: 20 )
    end

    attendance_experience_point.save!
    puts attendance_experience_point.id
    print attendance_experience_point

    self.update_attribute :experience_point_id, attendance_experience_point.id
  end
end
