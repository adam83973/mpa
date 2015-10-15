require 'rails_helper'

RSpec.describe "badge_modules/show", :type => :view do
  before(:each) do
    @badge_module = assign(:badge_module, BadgeModule.create!(
      :name => "Name",
      :badge_category_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
