require 'rails_helper'

RSpec.describe "HelpSessionRecords", type: :request do
  describe "GET /help_session_records" do
    it "works! (now write some real specs)" do
      get help_session_records_path
      expect(response).to have_http_status(200)
    end
  end
end
