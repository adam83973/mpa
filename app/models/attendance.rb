class Attendance < ActiveRecord::Base
  belongs_to :student
  belongs_to :offering
  belongs_to :experience_point

  validates_presence_of :offering_id, :student_id

  after_create :add_experience_point
  after_destroy :clean_up

  has_paper_trail if Rails.env.development? || Rails.env.production?

  COMMENTS = ["You made it to class!", "You're smarter because you came!", "Way to go! Here are some points for showing up :)", "You could have stayed home, but you decided to do brain pushups.", "The brain is strong in this one.", "See you next time!", "Thanks for coming!", "Great to see you. Here are some points."]


  private
    def add_experience_point
      attendance_xp = ExperiencePoint.create!(student_id:           student_id,
                                              experience_id:        experience_id_lookup,
                                              comment:              COMMENTS[rand(0..(COMMENTS.count - 1))] + "\n " + offering.offering_name,
                                              points:               20,
                                              user_id:              user_id)

      self.update_attribute :experience_point_id, attendance_xp.id
    end

    def clean_up
      if self.experience_point
        self.experience_point.destroy
      end
    end

    def experience_id_lookup
       experience_id = Experience.where(attendance: true, course_id: offering.course_id).pluck(:id).first.to_i

       experience_id = Experience.where(attendance: true, course_id: nil).pluck(:id).first.to_i if experience_id ==  0

       experience_id
    end
end
