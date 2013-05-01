class StaticPagesController < ApplicationController
  def home
    

    if signed_in?
      @user = current_user
      # if @user.offerings?
        @user_offerings = @user.offerings
        @user_location = @user.location
        @user_activity_feed = ExperiencePoint.where("user_id  = ? AND updated_at > ?", @user.id, 180.minutes.ago ).order('created_at desc')
      # end

      

      # ExperiencePoint.where("user_id = '#{@user.id}'").limit(20).order(:created_at)

      #   orders.where("created_at > ?", 30.days.ago)

      #   .order('id desc')
    end
    
    if params[:search]
      @users_search = User.search(params[:search])
    elsif 
      @user_search = []
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def search
  	
  end
end

