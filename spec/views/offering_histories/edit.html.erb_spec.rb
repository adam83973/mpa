require 'rails_helper'

RSpec.describe "offering_histories/edit", :type => :view do
  before(:each) do
    @offering_history = assign(:offering_history, OfferingHistory.create!(
      :offering_id => 1,
      :teacher_id => 1,
      :assistant_id => 1,
      :enrollment => 1
    ))
  end

  it "renders the edit offering_history form" do
    render

    assert_select "form[action=?][method=?]", offering_history_path(@offering_history), "post" do

      assert_select "input#offering_history_offering_id[name=?]", "offering_history[offering_id]"

      assert_select "input#offering_history_teacher_id[name=?]", "offering_history[teacher_id]"

      assert_select "input#offering_history_assistant_id[name=?]", "offering_history[assistant_id]"

      assert_select "input#offering_history_enrollment[name=?]", "offering_history[enrollment]"
    end
  end
end
