require 'spec_helper'
require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:parent){FactoryGirl.create(:parent)}
  let(:teacher){FactoryGirl.create(:teacher)}

  it "prints full name" do
    expect(parent.full_name).to eq("John Doe")
  end

  context "when location is assigned" do
    it "prints location name" do
      expect(parent.location.name).to eq('Powell')
    end
  end

  context "when role is teacher" do
    it "tells if they are a teacher" do
      expect(teacher.teacher?).to eq(true)
    end
    it "tells if they are a parent" do
      expect(teacher.parent?).to eq(false)
    end
  end

end
