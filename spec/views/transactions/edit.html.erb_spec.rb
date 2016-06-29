require 'rails_helper'

RSpec.describe "transactions/edit", type: :view do
  before(:each) do
    @transaction = assign(:transaction, Transaction.create!(
      :type => 1,
      :user_id => 1,
      :student_id => 1,
      :credits_redeemed => 1
    ))
  end

  it "renders the edit transaction form" do
    render

    assert_select "form[action=?][method=?]", transaction_path(@transaction), "post" do

      assert_select "input#transaction_type[name=?]", "transaction[type]"

      assert_select "input#transaction_user_id[name=?]", "transaction[user_id]"

      assert_select "input#transaction_student_id[name=?]", "transaction[student_id]"

      assert_select "input#transaction_credits_redeemed[name=?]", "transaction[credits_redeemed]"
    end
  end
end
