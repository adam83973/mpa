require "rails_helper"

RSpec.describe HelpSessionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/help_sessions").to route_to("help_sessions#index")
    end

    it "routes to #new" do
      expect(:get => "/help_sessions/new").to route_to("help_sessions#new")
    end

    it "routes to #show" do
      expect(:get => "/help_sessions/1").to route_to("help_sessions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/help_sessions/1/edit").to route_to("help_sessions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/help_sessions").to route_to("help_sessions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/help_sessions/1").to route_to("help_sessions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/help_sessions/1").to route_to("help_sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/help_sessions/1").to route_to("help_sessions#destroy", :id => "1")
    end

  end
end
