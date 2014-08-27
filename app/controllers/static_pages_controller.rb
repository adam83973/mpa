class StaticPagesController < ApplicationController
  skip_before_filter :authorize_active, only: [:enter_code, :mission_lookup]

  def home
    if signed_in?
      if current_user.parent?
        if Time.now > "20131216000001".to_datetime && Time.now < "20140615000001".to_datetime
          #add time sensitive flashes for parents...
        end
      end
      @user = current_user
      # if @user.offerings?
        @lead = Lead.new
        @note = Note.new
        @grade = Grade.new
        @experience_point = ExperiencePoint.new
        # @offerings = Offering.includes(:course, :location).order(:course_id)
        @user_location = @user.location
        @user_notes = @user.notes
        @user_action_needed = [] #user notings are added to this array as well as location leads
        @user.notings.includes(:user, :notable).where("completed = ? AND action_date <= ?", false, Date.today).each { |note| @user_action_needed << note }
        @new_students = Student.where("start_date < ? and start_date > ?", 6.days.from_now, 6.days.ago)
        @user_activity_feed = ExperiencePoint.includes(:experience, :student).where("user_id  = ? AND updated_at > ?", @user.id, 180.minutes.ago ).order('created_at desc')
        if current_user.teacher?
          @user_offerings = @user.offerings.includes(:course, :location)
          @offerings = Offering.includes(:course, :location).where("active = ?", true).order("course_id ASC")
        end
        if current_user.teacher? && class_session.in_session?
          @lessons = Lesson.includes(:standard, :resources, :problems).where("week = ?", "#{class_session.week}")
            @lessons.each do |lesson|
              if lesson.standard
                @todays_lesson = lesson if lesson.standard.course_id == Offering.find(class_session.offering).course_id
              end
            end
            if class_session.week.to_i - 1 == 0
              @last_weeks_lessons = Lesson.where("week = ?", "48")
              @last_weeks_lessons.each do |lesson|
                if lesson.standard
                  if Offering.find(class_session.offering).course_id == 1
                    nil
                  else
                    @last_weeks_lesson = lesson if lesson.standard.course_id == Offering.find(class_session.offering).course_id.to_i - 1
                  end
                end
              end
            else
              @last_weeks_lessons = Lesson.includes(:standard).where("week = ?", "#{class_session.week.to_i - 1}")
              @last_weeks_lessons.each do |lesson|
                @last_weeks_lesson = lesson if lesson.standard.course_id == Offering.includes(:course).find(class_session.offering).course_id
              end
            end
        end
        if @user_location
          @user_location.notes.where("completed = ? AND action_date <= ?", false, Date.today).each{ |note| @user_action_needed.push(note) unless @user_action_needed.include?(note)} #add location notes to user_action needed
          @hold_student_count = @user_location.students.find_all_by_status("Hold").count
          @location_offerings = @user_location.offerings.where("active = ?", true).order(:time)
          @todays_offering_by_location = Offering.where("active = ? AND location_id = ?", true, @user_location.id).includes(:course, :users).reject{|hash| hash[:day] != Time.now.strftime('%A') }
          @location_offerings_count = @location_offerings.count
          @new_students_location = @user_location.students.includes(:experience_points).where("start_date < ? and start_date > ?", 6.days.from_now, 6.days.ago).uniq
            @new_students_location.each do |student|
              if student.attended_first_class?
                @new_students_location.delete_if { |ns| ns["id"] == student.id }
              end
            end
          @student_restart = @user_location.students.where("status = ? AND restart_date < ?", "Hold", 20.days.from_now).order("restart_date ASC")
          @student_return = @user_location.students.where("return_date < ?", 20.days.from_now).order("return_date ASC")
        end
    end

    if params[:search]
      @users_search = User.search(params[:search])
      @offerings_search = Offering.search(params[:search])
      @students_search = Student.search(params[:search])
      @leads_search = Lead.search(params[:search])
    end
  end

  def enter_code
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

end
