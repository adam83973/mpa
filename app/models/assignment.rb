class Assignment < ActiveRecord::Base

  validates_presence_of :student_id, :score, :week, :offering_id
  # validates :course_id, uniqueness: { scope: :week }

  validates :comment, presence: true, length: {
    minimum: 5,
    tokenizer: lambda { |str| str.split(/\s+/) },
    too_short: "please write %{count} or more words"}
  belongs_to :student
  belongs_to :offering
  belongs_to :user
  belongs_to :experience_point

  before_save :add_course_id
  after_create :add_experience_point
  after_destroy :clean_up

  has_paper_trail if Rails.env.development? || Rails.env.production?

  SCORES = ["Incomplete", "Complete", "Perfect"]

  PRODUCTION_ASSIGNMENT_EXPERIENCE_ID = {0 => 4, 1 => 1, 2 => 5}
  TEST_ASSIGNMENT_EXPERIENCE_ID = 1
  DEVELOPMENT_ASSIGNMENT_EXPERIENCE_ID = {0 => 4, 1 => 1, 2 => 5}
  EXPERIENCE_POINTS_CONVERSION = {0 => 0, 1 => 60, 2 => 80}

  def self.completed?(student_id, week)
    self.where(student_id: student_id, week: week).any?
  end

  private
    def add_course_id
      self.course_id = Offering.find(offering_id).course_id
    end

    def add_experience_point
      if Rails.env.development?
        attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: DEVELOPMENT_ASSIGNMENT_EXPERIENCE_ID[score], comment: comment, points: EXPERIENCE_POINTS_CONVERSION[score], user_id: user_id )
      elsif Rails.env.production?
        attendance_experience_point = ExperiencePoint.create!(student_id: student_id, experience_id: PRODUCTION_ASSIGNMENT_EXPERIENCE_ID[score], comment: comment, points: EXPERIENCE_POINTS_CONVERSION[score], user_id: user_id )
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
