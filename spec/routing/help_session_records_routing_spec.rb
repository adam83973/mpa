require "rails_helper"

RSpec.describe HelpSessionRecordsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/help_session_records").to route_to("help_session_records#index")
    end

    it "routes to #new" do
      expect(:get => "/help_session_records/new").to route_to("help_session_records#new")
    end

    it "routes to #show" do
      expect(:get => "/help_session_records/1").to route_to("help_session_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/help_session_records/1/edit").to route_to("help_session_records#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/help_session_records").to route_to("help_session_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/help_session_records/1").to route_to("help_session_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/help_session_records/1").to route_to("help_session_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/help_session_records/1").to route_to("help_session_records#destroy", :id => "1")
    end

  end
end
