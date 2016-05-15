require 'rails_helper'

RSpec.describe "attendances/show", type: :view do
  let(:attendance){FactoryGirl.create(:attendance)}
  before(:each) do
    assign(:attendance, attendance)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{Date.today.to_s}/)
    expect(rendered).to match(/1/)
  end
end
