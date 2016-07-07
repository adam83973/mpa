task build_learning_plan_issues: :environment do
  build_learning_plan_issues
end

def build_learning_plan_issues
  LearningPlanIssue.create(title: "Struggling")
  LearningPlanIssue.create(title: "Confidence")
  LearningPlanIssue.create(title: "Bored")
  LearningPlanIssue.create(title: "Needs Challenge")
  LearningPlanIssue.create(title: "Doing Fine")
  LearningPlanIssue.create(title: "Focus")
end
