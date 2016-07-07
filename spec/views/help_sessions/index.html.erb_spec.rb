require 'rails_helper'

RSpec.describe "help_sessions/index", type: :view do
  before(:each) do
    assign(:help_sessions, [
      HelpSession.create!(
        :user_id => 1,
        :learning_plan_id => 2,
        :comments => "MyText",
        :parent_feedback => "MyText",
        :student_id => 3
      ),
      HelpSession.create!(
        :user_id => 1,
        :learning_plan_id => 2,
        :comments => "MyText",
        :parent_feedback => "MyText",
        :student_id => 3
      )
    ])
  end

  it "renders a list of help_sessions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
