require 'rails_helper'

RSpec.describe "badge_modules/new", :type => :view do
  before(:each) do
    assign(:badge_module, BadgeModule.new(
      :name => "MyString",
      :badge_category_id => 1
    ))
  end

  it "renders new badge_module form" do
    render

    assert_select "form[action=?][method=?]", badge_modules_path, "post" do

      assert_select "input#badge_module_name[name=?]", "badge_module[name]"

      assert_select "input#badge_module_badge_category_id[name=?]", "badge_module[badge_category_id]"
    end
  end
end
