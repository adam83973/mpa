require 'rails_helper'

RSpec.describe "OfferingHistories", :type => :request do
  describe "GET /offering_histories" do
    it "works! (now write some real specs)" do
      get offering_histories_path
      expect(response).to have_http_status(200)
    end
  end
end
