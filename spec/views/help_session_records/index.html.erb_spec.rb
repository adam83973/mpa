require 'rails_helper'

RSpec.describe "help_session_records/index", type: :view do
  before(:each) do
    assign(:help_session_records, [
      HelpSessionRecord.create!(
        :student_id => 1,
        :user_id => 2,
        :learning_plan_id => 3,
        :comments => "MyText",
        :parent_feedback => "MyText"
      ),
      HelpSessionRecord.create!(
        :student_id => 1,
        :user_id => 2,
        :learning_plan_id => 3,
        :comments => "MyText",
        :parent_feedback => "MyText"
      )
    ])
  end

  it "renders a list of help_session_records" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
