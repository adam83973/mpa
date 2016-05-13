class Attendance < ActiveRecord::Base
  belongs_to :student, dependent: :destroy
  belongs_to :offering
  belongs_to :experience_point, dependent: :destroy
end
