require 'rails_helper'

RSpec.describe "help_sessions/show", type: :view do
  before(:each) do
    @help_session = assign(:help_session, HelpSession.create!(
      :user_id => 1,
      :learning_plan_id => 2,
      :comments => "MyText",
      :parent_feedback => "MyText",
      :student_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/3/)
  end
end
