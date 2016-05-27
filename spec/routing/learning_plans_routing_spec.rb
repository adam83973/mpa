require "rails_helper"

RSpec.describe LearningPlansController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/learning_plans").to route_to("learning_plans#index")
    end

    it "routes to #new" do
      expect(:get => "/learning_plans/new").to route_to("learning_plans#new")
    end

    it "routes to #show" do
      expect(:get => "/learning_plans/1").to route_to("learning_plans#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/learning_plans/1/edit").to route_to("learning_plans#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/learning_plans").to route_to("learning_plans#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/learning_plans/1").to route_to("learning_plans#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/learning_plans/1").to route_to("learning_plans#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/learning_plans/1").to route_to("learning_plans#destroy", :id => "1")
    end

  end
end
