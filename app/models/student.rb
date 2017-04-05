class Student < ActiveRecord::Base

  attr_accessor :opportunity_id

  validates_presence_of :first_name, :last_name, :user_id

  has_paper_trail if Rails.env.development? || Rails.env.production?

  belongs_to :user
  belongs_to :location
  belongs_to :avatar
  belongs_to :learning_plan
  has_many :assignments, dependent: :destroy
  has_many :badge_requests
  has_many :badges, -> { where('badge_requests.approved = ?',true) },
           :through => :badge_requests,
           :class_name => "Badge",
           :source => :badge
  has_many :attendances, dependent: :destroy
  has_many :courses, :through => :offerings
  has_many :experiences, :through => :experience_points
  has_many :experience_points, dependent: :destroy
  has_many :grades, dependent: :destroy
  has_many :help_session_records
  has_many :learning_plans
  has_many :lessons , :through => :grades
  has_many :locations, :through => :offerings
  has_many :notes, as: :notable
  # has_many :occupations, :through => :courses
  has_many :offerings, :through => :registrations
  has_many :opportunities
  has_many :transactions
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
      if search.split.count == 2
        where('lower(first_name) LIKE ? AND lower(last_name) LIKE ?', "%#{search.split.first.downcase}%", "%#{search.split.last.downcase}%")
      else
        where('lower(first_name) LIKE ? OR lower(last_name) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%")
      end
    end
  end

  #-----Student Opportunities-----
  def active_opportunities?
    opportunities.where(status: 0..6).any?
  end

  #-----Student XP-----
  def redeemed_reward?(occupation_level_id)
    StudentLevelReward.exists?(occupation_level_id: occupation_level_id, student_id: id)
  end

  def xp_sum
    experience_points.sum(:points)
  end

  def last_attendance
    last_attendance = attendances.last
    if last_attendance
      last_attendance = last_attendance.date.to_date
    else
      last_attendance = experience_points.joins(:experience).where('experiences.name LIKE ?', '%Attendance%').last
      if last_attendance
        last_attendance = experience_points.joins(:experience).where('experiences.name LIKE ?', '%Attendance%').last.created_at.to_date
      else
        nil
      end
    end
  end

  def attendances_last_month
    attendances.where("date >= ? AND date <= ?", (Date.today - 1.month).beginning_of_month, (Date.today - 1.month).end_of_month)
  end

  def assignments_last_month
    assignments.where("created_at >= ? AND created_at <= ?", (Date.today - 1.month).beginning_of_month, (Date.today - 1.month).end_of_month)
  end

  def help_sessions_last_month
    help_session_records.where("created_at >= ? AND created_at <= ?", (Date.today - 1.month).beginning_of_month, (Date.today - 1.month).end_of_month)
  end

  def attended_help_sessions_last_month?
    help_sessions_last_month.any?
  end

  def last_assignment
    assignments.order("created_at desc").limit(1).first
  end

  #-----Student Credits-----
  def calculate_credit(experience_point)
    ((xp_sum + experience_point.points)/100 - ((xp_sum)/100))
  end

  def add_remove_credits(newcredit)
    if self.credits.nil?
      update_column(:credits, 1)
    else
      increment!(:credits,  newcredit)
    end
  end

  def redeem_credit(credits)
    credits = credits.to_i
    decrement!(:credits,  credits)
  end

  #-----Student rank-----
  def level_comp_percentage
    ((self.xp_sum.to_f - self.rank_points)/(1000)*100).round
  end

  #takes an array of offerings and converts to an array of the offerings course ids
  def class_ids
    self.offerings.map{|h| h['course_id'].to_i}
  end

  #-----Student Occupation-----
  def occupations
    occupations = []
    occupations << "Mathematician" if is_mathematician?
    occupations << "Engineer" if is_engineer?
    occupations << "Programmer" if is_programmer?
    occupations
  end

  def current_occupation_title
    Occupation.find(current_occupation_id).title
  end

  def in_robotics_class? #returns true if student is robotics student
    class_ids.include?(11)
  end

  def is_mathematician?
    Occupation.where(id: current_occupation_id).pluck(:title).first == 'Mathematician' || mathematician_experience_points > 0
  end

  def is_engineer?
    Occupation.where(id: current_occupation_id).pluck(:title).first == 'Engineer' || engineer_experience_points > 0
  end

  def is_programmer?
    Occupation.where(id: current_occupation_id).pluck(:title).first == 'Programmer' || programmer_experience_points > 0
  end

  #-----Student Levels-----
  def current_level(occupation_name)
    student_total_points_by_occupation = xp_sum_by_occupation(occupation_name)
    current_level = 0
    occupation = Occupation.where("title = ?", occupation_name).first
    occupation.occupation_levels.order(:level).each do |occupation_level|
      if occupation_level.points <= student_total_points_by_occupation
        current_level = occupation_level.level
      end
    end
    current_level
  end

  def current_level_by_occupation(occupation_name)
    case occupation_name
    when "mathematician"
      mathematician_level
    when "engineer"
      engineer_level
    when "programmer"
      programmer_level
    end
  end

  def current_level_obj(occupation_name)
    occupation_id = Occupation.where("title = ?", occupation_name).first.id
    OccupationLevel.where("occupation_id = ? AND level = ?", occupation_id, current_level(occupation_name)).first
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

  def sum_occupation_experience_points
    mathematician_experience_points + programmer_experience_points + engineer_experience_points
  end

  def xp_sum_by_occupation(occupation_name)
    case occupation_name
    when "Mathematician"
      mathematician_experience_points
    when "Programmer"
      programmer_experience_points
    when "Engineer"
      engineer_experience_points
    end
  end

  def update_occupation_experience_point_total(points)
    case Occupation.find(current_occupation_id).title
    when "Mathematician"
      increment!(:mathematician_experience_points, points)
    when "Programmer"
      increment!(:programmer_experience_points, points)
    when "Engineer"
      increment!(:engineer_experience_points, points)
    end

    update_column(:experience_point_total, sum_occupation_experience_points)
  end

  def update_occupation_experience_points_and_level(points)
    occupation = Occupation.find(current_occupation_id)
    update_occupation_experience_point_total(points)
    occupation_title = occupation.title
    case occupation_title.downcase
    when "mathematician"
      update_column(:mathematician_level, current_level(occupation_title).to_i)
    when "engineer"
      update_column(:engineer_level, current_level(occupation_title).to_i)
    when "programmer"
      update_column(:programmer_level, current_level(occupation_title).to_i)
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

  def assignment_scores_last_90_days(score)
    #possible grades ["perfect", "complete", "incomplete"]
    assignments.where("created_at > ? and score = ?", Date.today - 90.days, Assignment::SCORES.index(score.capitalize))
  end

  def active_registrations
    registrations.where(status: 1)
  end

  def active_math_classes
    active_registrations.to_a.delete_if{|registration| registration.course.occupation_id != 1 || registration.course.id == 10}
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
