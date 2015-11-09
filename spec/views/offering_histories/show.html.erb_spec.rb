require 'rails_helper'

RSpec.describe "offering_histories/show", :type => :view do
  before(:each) do
    @offering_history = assign(:offering_history, OfferingHistory.create!(
      :offering_id => 1,
      :teacher_id => 2,
      :assistant_id => 3,
      :enrollment => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
