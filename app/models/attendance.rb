class Attendance < ActiveRecord::Base
  belongs_to :student
  belongs_to :offering
  belongs_to :experience_point

  validates_presence_of :offering_id, :student_id

  after_create :add_experience_point
  after_destroy :clean_up

  has_paper_trail if Rails.env.development? || Rails.env.production?

  PRODUCTION_ATTENDANCE_EXPERIENCE_ID = { "mathematician" => 67, "programmer" => 69, "engineer" => 68 }
  TEST_ATTENDANCE_EXPERIENCE_ID = 1
  DEV_ATTENDANCE_BY_OCCUPATION = { "mathematician" => 58, "programmer" => 60, "engineer" => 61 }
  COMMENTS = ["You made it to class!", "You're smarter because you came!", "Way to go! Here are some points for showing up :)", "You could have stayed home, but you decided to do brain pushups.", "The brain is strong in this one.", "See you next time!", "Thanks for coming!", "Great to see you. Here are some points."]


  private
    def add_experience_point
      attendance_experience_point = ExperiencePoint.create!(student_id: student_id,
                                                            experience_id: select_experience_id_based_on_offering_occupation(Rails.env),
                                                            comment: COMMENTS[rand(0..(COMMENTS.count - 1))] + "\n " + offering.offering_name,
                                                            points: 20,
                                                            user_id: user_id )

      attendance_experience_point.save!

      self.update_attribute :experience_point_id, attendance_experience_point.id
    end

    def clean_up
      if self.experience_point
        self.experience_point.destroy
      end
    end

    def select_experience_id_based_on_offering_occupation(environment)
      case environment
      when "development"
        if offering.course_id == 10
          55 # set experience id if attendance is for a chess class
        else
          DEV_ATTENDANCE_BY_OCCUPATION[offering.occupation.title.downcase]
        end
      when "test"
        DEV_ATTENDANCE_BY_OCCUPATION
      when "production"
        if offering.course_id == 10
          74 # set experience id if attendance is for a chess class
        else
          PRODUCTION_ATTENDANCE_EXPERIENCE_ID[offering.occupation.title.downcase]
        end
      end
    end
end
