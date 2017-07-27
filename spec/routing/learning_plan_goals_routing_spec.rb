require "rails_helper"

RSpec.describe LearningPlanGoalsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/learning_plan_goals").to route_to("learning_plan_goals#index")
    end

    it "routes to #new" do
      expect(:get => "/learning_plan_goals/new").to route_to("learning_plan_goals#new")
    end

    it "routes to #show" do
      expect(:get => "/learning_plan_goals/1").to route_to("learning_plan_goals#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/learning_plan_goals/1/edit").to route_to("learning_plan_goals#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/learning_plan_goals").to route_to("learning_plan_goals#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/learning_plan_goals/1").to route_to("learning_plan_goals#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/learning_plan_goals/1").to route_to("learning_plan_goals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/learning_plan_goals/1").to route_to("learning_plan_goals#destroy", :id => "1")
    end

  end
end
