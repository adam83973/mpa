require 'rails_helper'

RSpec.describe "transactions/index", type: :view do
  before(:each) do
    assign(:transactions, [
      Transaction.create!(
        :type => 1,
        :user_id => 2,
        :student_id => 3,
        :credits_redeemed => 4
      ),
      Transaction.create!(
        :type => 1,
        :user_id => 2,
        :student_id => 3,
        :credits_redeemed => 4
      )
    ])
  end

  it "renders a list of transactions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
