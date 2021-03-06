require "rails_helper"

RSpec.describe LearningPlanIssuesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/learning_plan_issues").to route_to("learning_plan_issues#index")
    end

    it "routes to #new" do
      expect(:get => "/learning_plan_issues/new").to route_to("learning_plan_issues#new")
    end

    it "routes to #show" do
      expect(:get => "/learning_plan_issues/1").to route_to("learning_plan_issues#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/learning_plan_issues/1/edit").to route_to("learning_plan_issues#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/learning_plan_issues").to route_to("learning_plan_issues#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/learning_plan_issues/1").to route_to("learning_plan_issues#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/learning_plan_issues/1").to route_to("learning_plan_issues#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/learning_plan_issues/1").to route_to("learning_plan_issues#destroy", :id => "1")
    end

  end
end
