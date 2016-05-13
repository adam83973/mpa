class Student < ActiveRecord::Base

  #attr_accessible :birth_date, :first_name, :last_name, :offering_ids, :user_id,
                  # :start_date, :xp_total, :credits, :rank, :active, :status,
                  # :restart_date, :return_date, :end_date, :hold_status,
                  # :start_hold_date, :opportunity_id, :avatar_id, :avatar_background_color

  attr_accessor :opportunity_id

  validates_presence_of :first_name, :last_name, :user_id
  #validate presence of offerings

  has_paper_trail if Rails.env.development? || Rails.env.production?

  belongs_to :user
  belongs_to :location
  belongs_to :avatar
  has_many :badge_requests
  has_many :badges, -> { where('badge_requests.approved = ?',true) },
           :through => :badge_requests,
           :class_name => "Badge",
           :source => :badge
  has_many :courses, :through => :offerings
  has_many :experiences, :through => :experience_points
  has_many :experience_points, dependent: :destroy
  has_many :grades, dependent: :destroy
  has_many :lessons , :through => :grades
  has_many :locations, :through => :offerings
  has_many :notes, as: :notable
  has_many :occupations, :through => :courses
  has_many :offerings, :through => :registrations
  has_many :opportunities
  has_many :registrations, dependent: :destroy

  scope :active, lambda{where("status = ?", "Active")}
  scope :future_adds, lambda{where("start_date > ? AND status = ?", Date.today, "Inactive")}
  scope :added_last_30, lambda{where("start_date < ? and start_date > ?", Date.today, 30.days.ago)}
  scope :dropped_last_30, lambda{where("end_date < ? and end_date > ?", Date.tomorrow, 30.days.ago)}
  scope :restarting, lambda{where("status = ? AND restart_date < ?", "Hold", 20.days.from_now)}

  STATUSES = %w(Active Hold Inactive)
  HOLD_STATUSES = %w(Waiting Emailed Returning Quiting) # 0 - Waiting, 1 - Emailed, 2 - Returning, 3 - Quiting
  RESET_DATE = Date.parse('2014-8-24') #date to start count for gamification

  #-----Badge Logic-----
  def earned_badge(badge)
    badges.any?{|earned_badge| earned_badge.id == badge.id }
  end

  def earned_badges_with_count
    badge_count = Hash.new(0)
    badges.each do |badge|
      badge_count[badge] += 1
    end
    badge_count
  end

  def badges_earned_this_month
    badges.where("badge_requests.created_at > ? AND badge_requests.created_at < ?", Date.today.beginning_of_month, Date.today.end_of_month)
  end

  #-----Student attributes-----
  def full_name
      first_name + " " + last_name
  end

  def parent_name
      user.first_name + " " + user.last_name
  end

  def self.search(search)
    if search
      where('lower(first_name) LIKE ? OR lower(last_name) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%")
    end
  end

  #-----Student XP-----
  def xp_sum
    experience_points.sum(:points)
  end

  def last_attendance_xp
    experience_points.order("created_at desc").limit(1).joins(:experience).where("name LIKE ?", "%Attendance%").first
  end

  def attendance_last_month
    experience_points.joins(:experience).where("name LIKE ?", "%Attendance%").where("experience_points.created_at >= ? AND experience_points.created_at <= ?", (Date.today - 1.month).beginning_of_month, (Date.today - 1.month).end_of_month)
  end

  def assignments_last_month
    experience_points.joins(:experience).where("name LIKE ?", "%Homework%").where("experience_points.created_at >= ? AND experience_points.created_at <= ?", (Date.today - 1.month).beginning_of_month, (Date.today - 1.month).end_of_month)
  end

  def last_assignment_xp
    experience_points.order("created_at desc").limit(1).joins(:experience).where("name LIKE ?", "%Homework%").first
  end

  def xp_sum_by_occupation(cat)
    t = 0
    experience_points.where( "created_at > ?", Student::RESET_DATE ).includes(:experience, :occupation).each do |xp|
      if xp.occupation && xp.occupation.title == cat
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
  def in_robotics_class? #returns true if student is robotics student
    class_ids.include?(11)
  end

  def is_active_mathematician?
    math_class = false
    registrations.active.includes(:offering).each do |registration|
      if registration.offering.occupation.id == 1 # 1 = id for Mathematician
        math_class = true
      end
    end
    math_class
  end

  def is_mathematician?
    math_class = false
    offerings.includes(:occupation).each do |offering|
      if offering.occupation.id == 1 # 1 = id for Mathematician
        math_class = true
      end
    end
    math_class
  end

  def is_engineer?
    engineering_class = false
    offerings.includes(:occupation).each do |offering|
      if offering.occupation.id == 2 # 2 = id for Engineer
        engineering_class = true
      end
    end
    engineering_class
  end

  def is_programmer?
    programming_class = false
    offerings.includes(:occupation).each do |offering|
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
    occupation = Occupation.find_by_title(occupation_name)
    occupation.occupation_levels.order(:level).each do |level|
      if level.points <= points
        current_level = level.level
      end
    end
    current_level
  end

  def current_level_by_occupation(occupation_name)
    case occupation_name
    when "mathematician"
      math_level
    when "engineer"
      eng_level
    when "programmer"
      prog_level
    end
  end

  def current_level_obj(occupation_name)
    occupation_id = Occupation.find_by_title(occupation_name).id
    current_level_obj = OccupationLevel.where("occupation_id = ? AND level = ?", occupation_id, current_level(occupation_name)).first
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

  def percentage_of_level_completed(occupation_name)
    (((xp_sum_by_occupation(occupation_name).to_f - current_level_obj(occupation_name).points.to_f)/(next_level(occupation_name).points.to_f - current_level_obj(occupation_name).points.to_f))*100).to_i
  end

  def update_level(occupation_name)
    occupation = Occupation.where("title=?", occupation_name).first
    case occupation_name
    when "Mathematician"
      update_column(:math_level, current_level(occupation_name).to_i)
    when "Engineer"
      update_column(:eng_level, current_level(occupation_name).to_i)
    when "Programmer"
      update_column(:prog_level, current_level(occupation_name).to_i)
    else
      true
    end
  end

#-----Student Administration-----
  def is_inactive?
    !(registrations.any? { |reg| reg.status == 0 || reg.status == 1 })
  end

  def is_active?
    registrations.any? { |reg| reg.status == 0 || reg.status == 1 }
  end

  def self.actives
    active_students = []
    includes(:registrations).all.each do |student|
      if student.is_active?
        active_students << student
      end
    end
    active_students
  end


  def attended_first_class? #checks to see if student has attended first class
    experience_points.any? { |xp| xp.created_at >= start_date }
  end

  def last_date_attended #checks to see when student last attended class returns xp object
    experience_points.joins(:experience).where("name LIKE ?", "Attendance%").max_by {|xp| xp.created_at}
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

  def active_status
    if start_date && start_date <= Date.today && start_date > Date.today - 7.days
      self.status = "Active"
    else
      "false"
    end
  end

  def restart_active_status
    if restart_date && restart_date <= Date.today && restart_date > Date.today - 7.days
      if self.status == "Hold" || self.status == "Inactive"
        self.status = "Active"
      end
    else
      "false"
    end
  end

  def hold_status
    if start_hold_date && start_hold_date <= Date.today && start_hold_date > Date.today - 7.days
       self.status = "Hold"
    end
  end

  def inactive_status
    if end_date && end_date <= Date.today && end_date > Date.today - 7.days
      self.status = "Inactive"
    end
  end

  def homework_scores_last(number_of_days, experience_id=1)
    number_of_days = number_of_days.to_i
    experience_id = experience_id.to_i
    if experience_id == 1 || experience_id == 4 || experience_id == 5
      experience_points.
        where("created_at > ? and experience_id = ?", number_of_days.days.ago, experience_id).count
    else
      0
    end
  end

  def active_registrations
    registrations.where(status: 1)
  end

  def active_math_classes
    active_registrations.delete_if{|registration| registration.course.occupation_id != 1 || registration.course.id == 10}
  end

  #-----Student Information Management-----

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
