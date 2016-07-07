require 'rails_helper'

RSpec.describe "attendances/index", type: :view do
  let(:attendance){FactoryGirl.create(:attendance)}
  let(:attendance1){FactoryGirl.create(:attendance1)}
  let(:attendance2){FactoryGirl.create(:attendance2)}
  before(:each) do
    assign(:attendances, [ attendance, attendance1, attendance2 ])
  end

  it "renders a list of attendances" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 3
    assert_select "tr>td", :text => 2.to_s, :count => 3
    assert_select "tr>td", :text => 3.to_s, :count => 3
  end
end
