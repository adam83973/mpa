require 'rails_helper'

RSpec.describe "assignments/index", type: :view do
  before(:each) do
    assign(:assignments, [
      Assignment.create!(
        :student_id => 1,
        :score => 2,
        :corrected => false,
        :user_id => 3,
        :week => 4,
        :offering_id => 5
      ),
      Assignment.create!(
        :student_id => 1,
        :score => 2,
        :corrected => false,
        :user_id => 3,
        :week => 4,
        :offering_id => 5
      )
    ])
  end

  it "renders a list of assignments" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
