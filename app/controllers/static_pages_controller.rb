class StaticPagesController < ApplicationController
  def home
    if signed_in?
     @user = current_user
    end
    
    if params[:search]
      @users_search = User.search(params[:search])
    else
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

