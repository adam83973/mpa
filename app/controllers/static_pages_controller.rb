class StaticPagesController < ApplicationController
  def home
  	if params[:search].empty?
	else
	   q = params[:search]
	   p = "%#{q}%"
	   @users_search = User.where('first_name LIKE ? OR last_name LIKE ?', p, p).limit(10)
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

