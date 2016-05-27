require 'rails_helper'

RSpec.describe "LearningPlans", type: :request do
  describe "GET /learning_plans" do
    it "works! (now write some real specs)" do
      get learning_plans_path
      expect(response).to have_http_status(200)
    end
  end
end
