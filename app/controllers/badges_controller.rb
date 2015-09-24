class BadgesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin, except: [ :show, :index, :write_up_required ]

  # GET /badges
  # GET /badges.json
  def index
    @badges = Badge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @badges }
    end
  end

  # GET /badges/1
  # GET /badges/1.json
  def show
    set_badge

    @badge_request = BadgeRequest.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @badge }
    end
  end

  # GET /badges/new
  # GET /badges/new.json
  def new
    @badge = Badge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @badge }
    end
  end

  # GET /badges/1/edit
  def edit
    set_badge
  end

  # POST /badges
  # POST /badges.json
  def create
    @badge = Badge.new(params[:badge])

    respond_to do |format|
      if @badge.save
        format.html { redirect_to @badge, notice: 'Badge was successfully created.' }
        format.json { render json: @badge, status: :created, location: @badge }
      else
        format.html { render action: "new" }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /badges/1
  # PUT /badges/1.json
  def update
    set_badge

    respond_to do |format|
      if @badge.update_attributes(params[:badge])
        format.html { redirect_to @badge, notice: 'Badge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /badges/1
  # DELETE /badges/1.json
  def destroy
    set_badge
    @badge.destroy

    respond_to do |format|
      format.html { redirect_to badges_url }
      format.json { head :no_content }
    end
  end

  def write_up_required
    set_badge

    respond_to do |format|
      format.json { render json: @badge.write_up_required }
    end
  end

  def faq
  end

  private
  def set_badge
    @badge = Badge.find(params[:id])
  end
end
