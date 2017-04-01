class StaticPagesController < ApplicationController
  skip_before_filter :authorize_active, only: [:enter_code, :mission_lookup]
  before_filter :authorize_admin, only: [ :events, :event_enrollment ]

  def landing
  end

  def home
    if signed_in?
      @user = current_user
      if @user.parent?
        @badge_request = BadgeRequest.new
        @message = Message.new
      elsif @user.employee?

        set_user_location
        set_appointments

        if @user.teacher?
          set_teacher
          if class_session.in_session?
            set_class_session
          end
        end

        if @user.admin?
          set_admin
        end

        set_location # new students/trials/action notes
        set_search
      end
    end #end signed_in?
  end

  def enter_code
  end

  def events
    woocommerce = set_woo

    @workshops = woocommerce.get('products', {filter: {category: 'plus-series-event', limit: 20} }).parsed_response['products']
  end

  def event_enrollment
    woocommerce = set_woo

    id = params[:id]

    @workshop = woocommerce.get("products/#{id}").parsed_response['product']

    #pull orders of related product
    @orders = woocommerce.get("products/#{id}/orders", {filter: {limit: 20} }).parsed_response['orders']
    #remove cancelled orders
    @orders.to_a.to_a.delete_if{|order| order['status'] == 'cancelled'}
  end

  def badges
    @badges = Badge.all
    @badge_categories = BadgeCategory.all
  end

  def thank_you
  end

  def application_lookup
    subdomain = params[:company][:name].downcase
    if company = Company.find_by_subdomain(subdomain)
      redirect_to root_url(subdomain: subdomain)
    else
      redirect_to root_url, flash: { warning: "It doesn't look like there is an application that matches that name. Application names are all lower with no spaces or special characters." }
    end
  end

  def mission_lookup
    @code = params[:code]
    @decoded = Base64.decode64(@code)

    if !!(@decoded =~ /\b\d+\b/)
      @mission = Experience.find(@decoded)
    end

    if @mission && @mission.category == "Robotics"
      redirect_to @mission, notice: 'Code Accepted.'
    else
      redirect_to code_path, flash: { alert: "Invalid Code!" }
    end

    rescue ActiveRecord::RecordNotFound
      redirect_to code_url, flash: { alert: "Invalid Code!" }
  end

  def sample_student
  end

  private
    def set_admin
      @opportunity = Opportunity.new
      @note = Note.new
      @new_parent = User.new
      @generated_password = Devise.friendly_token.first(8)
      @new_student = Student.new
      @active_offerings = Offering.order(:course_id, :location_id, :day_number).includes(:course, :location).where("active = ?", true)
      @messages = Message.where(location_id: @user_location.id, status: 0)
      @badge_requests = @user_location.badge_requests.where(approved: false).uniq
      @user_notes = @user.notes
      @user_action_needed = [] #user notings are added to this array as well as location leads
      @user.notings.includes(:user, :notable).where("completed = ? AND action_date <= ? AND location_id = ?", false, Date.today, @user_location.id).each { |note| @user_action_needed << note }
      @new_students = Student.where("start_date < ? and start_date > ?", 6.days.from_now, 6.days.ago)
      @opps_need_action = @user_location.opportunities.where(status: 0..6).select { |opp| opp.last_note && opp.last_note.created_at > Date.today - 7.days }
    end

    def set_appointments
      @location_assessment_appointments = Appointment.where("time >= ? AND time < ? AND location_id = ?", Date.today, Date.today + 1.day, @user_location.id).where(reasonId: 37117).order(:time).to_a.to_a.delete_if{|appointment| appointment.status == "CANCELLED" || appointment.status == "DELETED"}

      @location_hw_help_appointments = Appointment.where("time >= ? AND time < ? AND location_id = ?", Date.today, Date.today + 1.day, @user_location.id).where(reasonId: 37118).order(:time).to_a.to_a.delete_if{|appointment| appointment.status == "CANCELLED" || appointment.status == "DELETED"}
    end

    def set_class_session
      @attendance = Attendance.new
      @class_session_offering = Offering.includes(:course).find(class_session.offering)
      @lessons = Lesson.includes(:resources, :problems).where("week = ?", "#{class_session.week}")
      @lessons.each do |lesson|
        @todays_lesson = lesson if lesson.course_id == @class_session_offering.course_id
      end
      if class_session.week.to_i - 1 == 0
        @last_weeks_lessons = Lesson.where("week = ?", "48")
        @last_weeks_lessons.each do |lesson|
          if @class_session_offering.course_id == 1
            nil
          else
            @last_weeks_lesson = lesson if lesson.course_id == @class_session_offering.course_id.to_i - 1
          end
        end
      else
        @last_weeks_lesson = Lesson.where("week = ? AND course_id = ?", "#{class_session.week.to_i - 1}", @class_session_offering.course_id).last
      end
    end

    def set_user_location
      @user_location = @user.location unless params[:location_id] || current_user.default_location
      if params[:location_id] || current_user.default_location
        if params[:location_id]
          if current_user.update_attribute :default_location, params[:location_id].to_i
            @user_location = Location.find(current_user.default_location)
          end
        else
          @user_location = Location.find(current_user.default_location)
        end
      end
    end

    def set_location
      if current_user.admin?
        @location_offerings = @user_location.offerings.where("active = ?", true).order(:time)
        @user_location.notes.includes(:notable, :user).where("completed = ? AND action_date <= ?", false, Date.today).each{ |note| @user_action_needed.push(note) unless @user_action_needed.include?(note)}
        #add location notes to user_action needed

        if Offering.any_today_location?(@user_location)
          @todays_offering_by_location = Offering.includes(:users).where("active = ? AND location_id = ?", true,      @user_location.id).includes(:course).reject{|hash| hash[:day] != Time.now.strftime('%A') }
        else
          @todays_offering_by_location = []
        end
        @location_offerings_count = @location_offerings.count
      end

      #Pull students that are or have started in +/- 6 days from today.
      @new_students_location = @user_location.registrations.where("start_date < ? and start_date > ?", 6.days.from_now, 6.days.ago).where(status: 0..1)

      #Pull students are starting or restarting within the next day.
      @new_students_today_location = @user_location.registrations.includes(:student, :offering, :course).where("start_date <= ? AND attended_first_class = ?", 1.day.from_now, false).where(status: 0..1)
      @restarting_students_today_location = @user_location.registrations.includes(:student, :offering, :course).where("restart_date <= ? AND attended_first_class = ?", 1.day.from_now, false).where(status: 0..1)
      @trials_today_location = @user_location.opportunities.includes(:student, :offering).where("trial_date <= ? AND attended_trial = ? AND missed_trial = ?", 1.day.from_now, false, false)
    end

    def set_teacher
      @attendance = Attendance.new
      @user_offerings = @user.offerings.where(active: true).includes(:course, :location)
      @offerings = Offering.includes(:course, :location).where("active = ?", true).order("course_id ASC").order("location_id ASC").order("day_number ASC") unless class_session.in_session?
      @students = Student.all
      @offering_in_session = Offering.find(class_session.offering) if class_session.in_session?
      @user_activity_feed = ExperiencePoint.includes(:experience, :student).where("user_id  = ? AND updated_at > ?", @user.id, 180.minutes.ago ).order('created_at desc')
    end

    def set_search
      if params[:search]
        @users_search = User.search(params[:search])
        @offerings_search = Offering.search do
          order_by(:course_id, :asc)
          fulltext params[:search]
        end
        @offerings_search = @offerings_search.results
        @offerings_search.to_a.delete_if{ |offering| !(offering.active?) }
        @students_search = Student.search(params[:search])
        @lessons_search = Lesson.search do
          with(:week, params[:search].gsub(/[a-zA-Z]|\s/,"").to_i)
          fulltext(params[:search].gsub(/[0-9]|\s/,""))
        end
        @lessons_search = @lessons_search.results
      end
    end

    def set_woo
      woocommerce = WooCommerce::API.new(
        "https://www.mathplusacademy.com/",
        ENV['WOO_CONSUMER_KEY'],
        ENV['WOO_CONSUMER_SECRET'],
        { meta: true }
      )
    end
end
