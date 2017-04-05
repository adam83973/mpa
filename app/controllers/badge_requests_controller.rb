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
    set_badge_request
    @badge = Badge.find(@badge_request.badge_id)
    @user = User.find(@badge_request.user_id)
  end

  def create
    @badge_request = BadgeRequest.new(badge_request_params)
    @badge = Badge.find(@badge_request.badge_id)
    @user = User.find(@badge_request.user_id)
    @student = Student.find(@badge_request.student_id)

    if @badge.multiple?
      save_badge_request
    elsif !@badge.multiple? && @student.earned_badge(@badge)
      flash[:alert] = 'It appears that this student has already earned this badge and can only earn it once. <strong>If you feel you have received this message in error please contact the Center Director.</strong>'.html_safe
    else
      save_badge_request
    end

    redirect_to student_path(@student)
  end

  def update
    @badge_request.update_attributes(badge_request_params)
    respond_with(@badge_request)
  end

  def approval
    set_badge_request
    @student = @badge_request.student
    @parent = @badge_request.user
    @badge = @badge_request.badge

    @badge_request.approve

    if @parent
      NotificationMailer.badge_request_approval_confirmation(@badge_request, @parent).deliver
    end

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

    def badge_request_params
      params.require(:badge_request).permit(:approved, :badge_id, :parent_submission, :student_id, :user_id,
                                            :date_approved, :write_up)
    end

    def save_badge_request
      if @badge_request.save
        badge = @badge_request.badge
        experience = badge.experience

        flash_content = "Your badge request was received. "

        if @badge_request.badge.requires_approval?
          flash_content = flash_content +  "We will process it shortly."
        elsif @badge_request.badge.requires_approval? || current_user.employee?
          if @badge_request.approve
            flash_content = flash_content + "Your badge request has been approved. #{experience.points} experience points awarded"
          end
        else
          if @badge_request.approve
            flash_content = flash_content + "Your badge request has been approved. #{experience.points} experience points awarded"
          end
        end

        flash[:notice] = flash_content

        NotificationMailer.badge_request_confirmation(@badge_request, @user).deliver unless @user.employee? || @badge_request.approved?
      end
    end
end
