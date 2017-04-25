class Assignment < ActiveRecord::Base

  validates_presence_of :student_id, :score, :week, :offering_id
  validates :student_id, uniqueness: { scope: [:course_id, :week], message: 'already has an assignment recorded for this week # and class.' }

  validates :comment, presence: true, length: {
    minimum: 5,
    tokenizer: lambda { |str| str.split(/\s+/) },
    too_short: "this comment is not long enough. Write something a bit longer ;) These comments go a long way."}

  belongs_to :student
  belongs_to :offering
  belongs_to :course
  belongs_to :user
  belongs_to :experience_point

  after_create :add_experience_point
  after_destroy :clean_up
  after_update :update_experience_point

  has_paper_trail if Rails.env.development? || Rails.env.production?

  SCORES = ["Incomplete", "Complete", "Perfect"]

  def self.completed?(student_id, week)
    self.where(student_id: student_id, week: week).any?
  end

  def course_name
    course ? course.name : ""
  end

  private

    def add_experience_point
      experience = Experience.where("assignment = ? AND name LIKE ?", true, "%#{SCORES[score]}%").first
      assignment_xp = ExperiencePoint.create!(student_id:    student_id,
                                              experience_id: experience.id,
                                              comment:       comment,
                                              points:        experience.points,
                                              user_id:       user_id )

      self.update_attribute :experience_point_id, assignment_xp.id
    end

    def update_experience_point
      experience = Experience.where("assignment = ? AND name LIKE ?", true, "%#{SCORES[score]}%").first

      experience_point.update_attributes(experience_id: experience.id,
                                         comment:       comment,
                                         points:        experience.points,
                                         user_id:       user_id)
    end

    def clean_up
      if experience_point
        experience_point.destroy
      end
    end

    def student_unique_per_class_per_week
      if self.class.exists?(student_id: student_id, course_id: course_id, week: week)
        errors.add :assignment, 'already exists for this combination of student, class, and week.'
      end
    end
end
