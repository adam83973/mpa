require 'rails_helper'

RSpec.describe "LearningPlanGoals", type: :request do
  describe "GET /learning_plan_goals" do
    it "works! (now write some real specs)" do
      get learning_plan_goals_path
      expect(response).to have_http_status(200)
    end
  end
end
