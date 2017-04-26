class AdminsController < ApplicationController
  skip_before_action :authorize_active
  def home
    @companies = Company.all

    respond_to do |format|
      format.html
    end
  end

  def company
    @company = Company.find(params[:id])
  end
end
