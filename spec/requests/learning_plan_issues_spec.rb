require 'rails_helper'

RSpec.describe "LearningPlanIssues", type: :request do
  describe "GET /learning_plan_issues" do
    it "works! (now write some real specs)" do
      get learning_plan_issues_path
      expect(response).to have_http_status(200)
    end
  end
end
