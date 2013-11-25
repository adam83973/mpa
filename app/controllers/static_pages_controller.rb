class StaticPagesController < ApplicationController

  def home
    if signed_in?
      if current_user.parent?
        flash[:notice] = "Read this! Bonus code is 'active25'. Go to this <a href='http://www.mathplusacademy.com/events/category/holiday-camps/'>link</a> to register for Winter Camps and save!".html_safe
      end
      @user = current_user
      # if @user.offerings?
        @grade = Grade.new
        @experience_point = ExperiencePoint.new
        @offerings = Offering.order(:course_id)
        @user_offerings = @user.offerings
        @user_location = @user.location
        @new_students = Student.where("start_date < ? and start_date > ?", 6.days.from_now, 6.days.ago)
        @user_activity_feed = ExperiencePoint.where("user_id  = ? AND updated_at > ?", @user.id, 180.minutes.ago ).order('created_at desc')
        if current_user.teacher? && class_session.in_session?
          @lessons = Lesson.where("week = ?", "#{class_session.week}")
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
              @last_weeks_lessons = Lesson.where("week = ?", "#{class_session.week.to_i - 1}")
              @last_weeks_lessons.each do |lesson|
                @last_weeks_lesson = lesson if lesson.standard.course_id == Offering.find(class_session.offering).course_id
              end
            end
        end
        if @user_location
          @hold_student_count = @user_location.students.find_all_by_status("Hold").count
          @location_offerings_count = @user_location.offerings.where("active = ?", true).count
          @new_students_location = @user_location.students.where("start_date < ? and start_date > ?", 6.days.from_now, 6.days.ago).uniq
            @new_students_location.each do |student|
              if student.attended_first_class?
                @new_students_location.delete_if { |ns| ns["id"] == student.id }
              end
            end
          @student_restart = @user_location.students.where("status = ? AND restart_date < ?", "Hold", 20.days.from_now)
          @student_return = @user_location.students.where("status = ? AND return_date < ?", "Hold", 20.days.from_now)
        end
    end

    params[:search] ? @users_search = User.search(params[:search]) : @user_search = []

  end
end

