require 'rails_helper'

RSpec.describe "BadgeModules", :type => :request do
  describe "GET /badge_modules" do
    it "works! (now write some real specs)" do
      get badge_modules_path
      expect(response).to have_http_status(200)
    end
  end
end
