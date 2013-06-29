class Student < ActiveRecord::Base
  attr_accessible :birth_date, :first_name, :last_name, :offering_ids, :user_id, :start_date, :xp_total, :credits, :rank, :active, :status

  validates_presence_of :first_name, :last_name, :user_id

  belongs_to :user
  belongs_to :location
  has_many :grades
  has_many :lessons , :through => :grades
  has_many :experiences, :through => :experience_points
  has_many :locations, :through => :offerings
  has_many :courses, :through => :offerings
  has_many :experience_points, dependent: :destroy
  has_and_belongs_to_many :offerings

  def full_name
      first_name + " " + last_name
  end

  def parent_name
      user.first_name + " " + user.last_name
  end

  def xp_sum
    experience_points.sum(:points)
  end

  def calculate_xp
    update_column(:xp_total, xp_sum)
  end

  def calculate_credit(experience_point)
    ((xp_sum + experience_point.points)/100 - ((xp_sum)/100))
  end

  def add_credit(newcredit)
    if self.credits.nil?
      update_column(:credits, 1)
    else
      increment!(:credits,  newcredit)
    end
  end

  def calculate_rank(experience_point)
    ((xp_sum + experience_point.points)/1000 - ((xp_sum)/1000))
  end

  def update_rank
    if self.rank.nil?
      update_column(:rank, 'Classified')
    elsif self.rank == "Classified"
      update_column(:rank, 'Confidential')
    elsif self.rank == "Confidential"
      update_column(:rank, 'Secret')
    elsif self.rank == "Secret"
      update_column(:rank, 'Top Secret')
    else self.rank == "Top Secret"
      update_column(:rank, 'Classified')
    end
  end

  def decrease_rank
    if self.rank == "Confidential"
      update_column(:rank, 'Classified')
    elsif self.rank == "Secret"
      update_column(:rank, 'Confidential')
    else self.rank == "Top Secret"
      update_column(:rank, 'Secret')
    end
  end

  def next_rank
    if self.rank == 'Classified'
      "Confidential"
    elsif self.rank == 'Confidential'
      "Secret"
    elsif self.rank == "Secret"
      "Top Secret"
    else self.rank == "Top Secret"
      "You've reached the top... For now."
    end
  end

  def rank_points
    if self.rank == 'Classified'
      0
    elsif self.rank == 'Confidential'
      1000
    elsif self.rank == "Secret"
      2000
    else self.rank == "Top Secret"
      3000
    end
  end

#takes an array of offerings and converts to an array of the offerings course ids
  def class_ids
    self.offerings.map{|h| h['course_id'].to_i}
  end

#returns true if student is robotics student
  def robotics
    class_ids.include?(11)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      student = find_by_id(row["id"]) || new
      student.attributes = row.to_hash.slice(*accessible_attributes)
      student.save!
    end
  end
end