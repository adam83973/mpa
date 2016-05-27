class LearningPlan < ActiveRecord::Base

  validates_presence_of :student_id, :user_id, :course_id, :learning_plan_issue_id

  belongs_to :user
  belongs_to :student
  belongs_to :course
  has_many :help_sessions
  belongs_to :learning_plan_issue
  has_many :goals, class_name: 'LearningPlanGoal', dependent: :destroy

  accepts_nested_attributes_for :goals
  before_validation :mark_goals_for_destruction
  after_create :flag_student

  private

    def mark_goals_for_destruction
      goals.each do |goal|
        if goal.name.blank?
          goal.mark_for_destruction
        end
      end
    end

    def flag_student
      student.update_attribute :has_learning_plan, true if student
    end
end
