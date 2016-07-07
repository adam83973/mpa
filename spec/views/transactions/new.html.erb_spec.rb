require 'rails_helper'

RSpec.describe "transactions/new", type: :view do
  before(:each) do
    assign(:transaction, Transaction.new(
      :type => 1,
      :user_id => 1,
      :student_id => 1,
      :credits_redeemed => 1
    ))
  end

  it "renders new transaction form" do
    render

    assert_select "form[action=?][method=?]", transactions_path, "post" do

      assert_select "input#transaction_type[name=?]", "transaction[type]"

      assert_select "input#transaction_user_id[name=?]", "transaction[user_id]"

      assert_select "input#transaction_student_id[name=?]", "transaction[student_id]"

      assert_select "input#transaction_credits_redeemed[name=?]", "transaction[credits_redeemed]"
    end
  end
end
