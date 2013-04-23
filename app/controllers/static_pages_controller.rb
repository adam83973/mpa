class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      # if @user.offerings?
        @user_offerings = @user.offerings
      # end
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

