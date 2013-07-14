class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      # if @user.offerings?
        @user_offerings = @user.offerings
        @user_location = @user.location
        @new_students = Student.where("start_date < ? and start_date > ?", 6.days.from_now, 6.days.ago)
        @user_activity_feed = ExperiencePoint.where("user_id  = ? AND updated_at > ?", @user.id, 180.minutes.ago ).order('created_at desc')
        if @user_location
          @active_student_count = @user_location.students.find_all_by_status("Active").count
          @hold_student_count = @user_location.students.find_all_by_status("Hold").count
          @student_restart = @user_location.students.where("status = ? AND restart_date != ? AND restart_date < ?", "Hold", "nil", 20.days.from_now)
          @student_return = @user_location.students.where("status = ? AND return_date != ? AND return_date < ?", "Hold", "nil", 20.days.from_now)
        end
    end

    if params[:search]
      @users_search = User.search(params[:search])
    else
      @user_search = []
    end
  end
end

