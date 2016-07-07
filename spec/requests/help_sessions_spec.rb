require 'rails_helper'

RSpec.describe "HelpSessions", type: :request do
  describe "GET /help_sessions" do
    it "works! (now write some real specs)" do
      get help_sessions_path
      expect(response).to have_http_status(200)
    end
  end
end
