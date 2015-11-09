require 'rails_helper'

RSpec.describe "offering_histories/index", :type => :view do
  before(:each) do
    assign(:offering_histories, [
      OfferingHistory.create!(
        :offering_id => 1,
        :teacher_id => 2,
        :assistant_id => 3,
        :enrollment => 4
      ),
      OfferingHistory.create!(
        :offering_id => 1,
        :teacher_id => 2,
        :assistant_id => 3,
        :enrollment => 4
      )
    ])
  end

  it "renders a list of offering_histories" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
