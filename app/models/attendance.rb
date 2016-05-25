class Attendance < ActiveRecord::Base
  belongs_to :student
  belongs_to :offering
  belongs_to :experience_point

  after_create :add_experience_point
  after_destroy :clean_up

  has_paper_trail if Rails.env.development? || Rails.env.production?

  PRODUCTION_ATTENDANCE_EXPERIENCE_ID = 1
  TEST_ATTENDANCE_EXPERIENCE_ID = 1
  DEVELOPMENT_ATTENDANCE_EXPERIENCE_ID = 86
  COMMENTS = ["You made it to class!", "You're smarter because you came!", "Way to go! Here are some points for showing up :)", "You could have stayed home, but you decided to do brain pushups.", "The brain is strong in this one.", "See you next time!", "Thanks for coming!", "Great to see you. Here are some points."]


  private
    def add_experience_point
      if Rails.env.development?
        attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: DEVELOPMENT_ATTENDANCE_EXPERIENCE_ID, comment: COMMENTS[rand(0..(COMMENTS.count - 1))], points: 20, user_id: user_id )
      elsif Rails.env.production?
        attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: PRODUCTION_ATTENDANCE_EXPERIENCE_ID, comment: COMMENTS[rand(0..(COMMENTS.count - 1))], points: 20, user_id: user_id )
      else
        attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: TEST_ATTENDANCE_EXPERIENCE_ID, comment: COMMENTS[rand(0..(COMMENTS.count - 1))], points: 20 )
      end

      attendance_experience_point.save!

      self.update_attribute :experience_point_id, attendance_experience_point.id
    end

    def clean_up
      if self.experience_point
        self.experience_point.destroy
      end
    end
end
