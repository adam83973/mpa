require 'rails_helper'

RSpec.describe "badge_modules/index", :type => :view do
  before(:each) do
    assign(:badge_modules, [
      BadgeModule.create!(
        :name => "Name",
        :badge_category_id => 1
      ),
      BadgeModule.create!(
        :name => "Name",
        :badge_category_id => 1
      )
    ])
  end

  it "renders a list of badge_modules" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
