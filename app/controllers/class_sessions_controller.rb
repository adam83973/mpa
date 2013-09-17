class ClassSessionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee

  def new
  end

  def create
    @class_session = ClassSession.new(session)
    @class_session.add_week(params[:week])
    @class_session.add_offering_id(params[:offering])
    redirect_to root_url
  end

  def destroy
  end
end
