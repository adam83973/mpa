require 'rails_helper'

RSpec.describe "help_session_records/show", type: :view do
  before(:each) do
    @help_session_record = assign(:help_session_record, HelpSessionRecord.create!(
      :student_id => 1,
      :user_id => 2,
      :learning_plan_id => 3,
      :comments => "MyText",
      :parent_feedback => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
