require 'rails_helper'

RSpec.describe "help_sessions/edit", type: :view do
  before(:each) do
    @help_session = assign(:help_session, HelpSession.create!(
      :user_id => 1,
      :learning_plan_id => 1,
      :comments => "MyText",
      :parent_feedback => "MyText",
      :student_id => 1
    ))
  end

  it "renders the edit help_session form" do
    render

    assert_select "form[action=?][method=?]", help_session_path(@help_session), "post" do

      assert_select "input#help_session_user_id[name=?]", "help_session[user_id]"

      assert_select "input#help_session_learning_plan_id[name=?]", "help_session[learning_plan_id]"

      assert_select "textarea#help_session_comments[name=?]", "help_session[comments]"

      assert_select "textarea#help_session_parent_feedback[name=?]", "help_session[parent_feedback]"

      assert_select "input#help_session_student_id[name=?]", "help_session[student_id]"
    end
  end
end
