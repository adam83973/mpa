require "rails_helper"

RSpec.describe BadgeModulesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/badge_modules").to route_to("badge_modules#index")
    end

    it "routes to #new" do
      expect(:get => "/badge_modules/new").to route_to("badge_modules#new")
    end

    it "routes to #show" do
      expect(:get => "/badge_modules/1").to route_to("badge_modules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/badge_modules/1/edit").to route_to("badge_modules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/badge_modules").to route_to("badge_modules#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/badge_modules/1").to route_to("badge_modules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/badge_modules/1").to route_to("badge_modules#destroy", :id => "1")
    end

  end
end
