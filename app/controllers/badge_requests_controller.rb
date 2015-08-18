class BadgeRequestsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorize_admin, except: [ :show, :new, :create ]
  before_filter :set_badge_request, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @badge_requests = BadgeRequest.all
    respond_with(@badge_requests)
  end

  def show
    respond_with(@badge_request)
  end

  def new
    @badge_request = BadgeRequest.new
    respond_with(@badge_request)
  end

  def edit
  end

  def create
    @badge_request = BadgeRequest.new(params[:badge_request])
    @parent = User.find params[:badge_request][:user_id]
    if @badge_request.save
      flash[:notice] = "Your badge request was received. We will process it shortly."
      NotificationMailer.badge_request_confirmation(@badge_request, @parent).deliver
    end
    respond_with(@badge_request, location: root_url)
  end

  def update
    @badge_request.update_attributes(params[:badge_request])
    respond_with(@badge_request)
  end

  def approval
    @badge_request = BadgeRequest.find(params[:id])
    @student = @badge_request.student
    @parent = @badge_request.user
    @badge = @badge_request.badge

    @badge_request.approve
    
    NotificationMailer.badge_request_approval_confirmation(@badge_request, @parent).deliver

    BadgesStudent.create(badge_id: @badge.id, student_id: @student.id) #award badge to student

    # BadgesStudent.create(student_id: badge_request.student_id, badge_id: badge_request.badge_id)
    render nothing: true
  end

  def destroy
    @badge_request.destroy
    respond_with(@badge_request)
  end

  private
    def set_badge_request
      @badge_request = BadgeRequest.find(params[:id])
    end
end
