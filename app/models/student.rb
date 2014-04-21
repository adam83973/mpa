class Student < ActiveRecord::Base

  attr_accessible :birth_date, :first_name, :last_name, :offering_ids, :user_id,
                  :start_date, :xp_total, :credits, :rank, :active, :status,
                  :restart_date, :return_date, :end_date

  validates_presence_of :first_name, :last_name, :user_id

  belongs_to :user
  belongs_to :location
  has_many :grades
  has_many :lessons , :through => :grades
  has_many :experiences, :through => :experience_points
  has_many :locations, :through => :offerings
  has_many :courses, :through => :offerings
  has_many :occupations, :through => :courses
  has_many :experience_points, dependent: :destroy
  has_and_belongs_to_many :offerings

  #-----Student attributes-----

  def full_name
      first_name + " " + last_name
  end

  def parent_name
      user.first_name + " " + user.last_name
  end

  #-----Student XP-----

  def xp_sum
    experience_points.sum(:points)
  end

  def xp_sum_by_occupation(cat)
    t = 0
    experience_points.each do |xp|
      if xp.experience.occupation && xp.experience.occupation.title == cat
        t += xp.points
      end
    end
    t
  end

  def calculate_xp
    update_column(:xp_total, xp_sum)
  end

  #-----Student Credits-----

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

  def redeem_credit(creds)
    credits = creds.to_i
    credits = - credits
      increment!(:credits,  credits)
  end

  #-----Student rank-----

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

  def level_comp_percentage
    ((self.xp_sum.to_f - self.rank_points)/(1000)*100).round
  end

#takes an array of offerings and converts to an array of the offerings course ids
  def class_ids
    self.offerings.map{|h| h['course_id'].to_i}
  end

  #-----Student Occupation-----

#returns true if student is robotics student
  def in_robotics_class?
    class_ids.include?(11)
  end

  def is_mathematician?
    math_class = false
    offerings.each do |offering|
      if offering.occupation.id == 1 # 1 = id for Mathematician
        math_class = true
      end
    end
    math_class
  end

  def is_engineer?
    engineering_class = false
    offerings.each do |offering|
      if offering.occupation.id == 2 # 2 = id for Engineer
        engineering_class = true
      end
    end
    engineering_class
  end

  def is_programmer?
    programming_class = false
    offerings.each do |offering|
      if offering.occupation.id == 3 # 1 = id for Programmer
        programming_class = true
      end
    end
    programming_class
  end

  #-----Student Levels-----

  def current_level(occupation_name)
    points = xp_sum_by_occupation(occupation_name)
    current_level = 0
    occupation = Occupation.where("title=?", occupation_name).first
    occupation.occupation_levels.each do |level|
      if level.points < current_level
        current_level = level.level
      end
    end
    current_level
  end

  def points_to_next_level(occupation_name)
    occupation_id = Occupation.where("title=?", occupation_name).first.id
    next_level = OccupationLevel.where("occupation_id = ? AND level = ?", occupation_id, current_level(occupation_name) + 1).first
    points = next_level.points - xp_sum_by_occupation(occupation_name)
    points
  end

  def next_level(occupation_name)
    occupation_id = Occupation.where("title=?", occupation_name).first.id
    next_level = OccupationLevel.where("occupation_id = ? AND level = ?", occupation_id, current_level(occupation_name) + 1).first
    next_level
  end

  #-----Student Administration-----

#checks to see if student has attended first class
  def attended_first_class?
    !experience_points.empty?
  end

#checks to see if when student last attended class
  def last_date_attended
    experience_points.where("experience_id = ?", 2).last
  end

  def hold_date_status
    if self.status == "Hold" && self.return_date != nil
        "#{self.return_date.strftime("%D")} Returning"
    elsif self.status == "Hold" && self.restart_date != nil
        "#{self.restart_date.strftime("%D")} Restarting"
    elsif self.status == "Hold" && self.restart_date.nil? && return_date.nil?
        "Add date"
    else
      ""
    end
  end



  #-----Student Attendance-----

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      student = find_by_id(row["id"]) || new
      student.attributes = row.to_hash.slice(*accessible_attributes)
      student.save!
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |student|
        csv << student.attributes.values_at(*column_names)
      end
    end
  end
end
