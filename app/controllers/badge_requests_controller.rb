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
    @parent = params[:badge_request][:user_id]
    if @badge_request.save
      NotificationMailer.badge_request_confirmation(@badge_request, @parent)
    end
    respond_with(@badge_request)
  end

  def update
    @badge_request.update_attributes(params[:badge_request])
    respond_with(@badge_request)
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
