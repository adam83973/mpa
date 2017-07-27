require 'rails_helper'

RSpec.describe "help_session_records/new", type: :view do
  before(:each) do
    assign(:help_session_record, HelpSessionRecord.new(
      :student_id => 1,
      :user_id => 1,
      :learning_plan_id => 1,
      :comments => "MyText",
      :parent_feedback => "MyText"
    ))
  end

  it "renders new help_session_record form" do
    render

    assert_select "form[action=?][method=?]", help_session_records_path, "post" do

      assert_select "input#help_session_record_student_id[name=?]", "help_session_record[student_id]"

      assert_select "input#help_session_record_user_id[name=?]", "help_session_record[user_id]"

      assert_select "input#help_session_record_learning_plan_id[name=?]", "help_session_record[learning_plan_id]"

      assert_select "textarea#help_session_record_comments[name=?]", "help_session_record[comments]"

      assert_select "textarea#help_session_record_parent_feedback[name=?]", "help_session_record[parent_feedback]"
    end
  end
end
