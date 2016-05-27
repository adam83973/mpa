class Assignment < ActiveRecord::Base

  validates_presence_of :student_id, :score, :week, :offering_id
  validates :comment, presence: true, length: {
    minimum: 5,
    tokenizer: lambda { |str| str.split(/\s+/) },
    too_short: "please write %{count} or more words"}
  belongs_to :student
  belongs_to :offering
  belongs_to :user
  belongs_to :experience_point

  after_create :add_experience_point
  after_destroy :clean_up

  has_paper_trail if Rails.env.development? || Rails.env.production?

  SCORES = ["Incomplete", "Complete", "Perfect"]

  PRODUCTION_ASSIGNMENT_EXPERIENCE_ID = 1
  TEST_ASSIGNMENT_EXPERIENCE_ID = 1
  DEVELOPMENT_ASSIGNMENT_EXPERIENCE_ID = 87
  EXPERIENCE_POINTS_CONVERSION = {0 => 0, 1 => 60, 2 => 80}

  def self.completed?(student_id, week)
    self.where(student_id: student_id, week: week).any?
  end

  private
    def add_experience_point
      if Rails.env.development?
        if self.score > 0
          attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: DEVELOPMENT_ASSIGNMENT_EXPERIENCE_ID, comment: "You did a very nice job on this assignment. Please focus on checking your work.", points: EXPERIENCE_POINTS_CONVERSION[self.score], user_id: user_id )
        end
      elsif Rails.env.production?
        attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: PRODUCTION_ATTENDANCE_EXPERIENCE_ID, comment: COMMENTS[rand(0..(COMMENTS.count - 1))], points: 20, user_id: user_id )
      else
        attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: TEST_ASSIGNMENT_EXPERIENCE_ID, comment: COMMENTS[rand(0..(COMMENTS.count - 1))], points: 20 )
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
