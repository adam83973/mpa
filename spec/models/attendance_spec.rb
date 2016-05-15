require 'rails_helper'

RSpec.describe Attendance, type: :model do
  let(:attendance_experience){FactoryGirl.create(:attendance_experience)}
  let(:attendance){FactoryGirl.build(:attendance)}

  it "prints date" do
    expect(attendance.date).to eq(Date.today)
  end

  it "returns student id" do
    expect(attendance.student.id).to eq(1)
  end
end
