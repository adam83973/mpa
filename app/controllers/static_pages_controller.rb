class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      # if @user.offerings?
        @user_offerings = @user.offerings
        @user_location = @user.location
        @user_activity_feed = ExperiencePoint.where("user_id  = ? AND updated_at > ?", @user.id, 180.minutes.ago ).order('created_at desc')
        @active_student_count = @user_location.students.calculate(:count, :active)
    end

    if params[:search]
      @users_search = User.search(params[:search])
    elsif
      @user_search = []
    end
  end
end

