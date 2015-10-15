require 'rails_helper'

RSpec.describe "badge_modules/edit", :type => :view do
  before(:each) do
    @badge_module = assign(:badge_module, BadgeModule.create!(
      :name => "MyString",
      :badge_category_id => 1
    ))
  end

  it "renders the edit badge_module form" do
    render

    assert_select "form[action=?][method=?]", badge_module_path(@badge_module), "post" do

      assert_select "input#badge_module_name[name=?]", "badge_module[name]"

      assert_select "input#badge_module_badge_category_id[name=?]", "badge_module[badge_category_id]"
    end
  end
end
