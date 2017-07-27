require 'rails_helper'

RSpec.describe Badge, :type => :model do
  let(:research){BadgeCategory.create!(name: 'Research', multiple: false)}

  let(:pascal){Badge.create!(name: "Pascal's Triangle", experience_id: 81, requirements: "Research Pascal's Triangle and complete a short", badge_category_id: research.id)}

  let(:experience){Experience.create!(name: 'Completed Research Project', points: 100, content: 'You did it!')}

  it "prints badge category name" do
    expect(pascal.category_name).to eq('Research')
  end
end
