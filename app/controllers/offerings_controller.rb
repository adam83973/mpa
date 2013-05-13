class OfferingsController < ApplicationController
  before_filter :authenticate_user!

  # GET /offerings
  # GET /offerings.json
  def index
    @offerings = Offering.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offerings }
    end
  end

  # GET /offerings/1
  # GET /offerings/1.json
  def show
    @offering = Offering.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offering }
    end
  end

  # GET /offerings/new
  # GET /offerings/new.json
  def new
    @offering = Offering.new
    @teachers = @parents = User.where("role = ?", "Teacher").order('last_name')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offering }
    end
  end

  # GET /offerings/1/edit
  def edit
    @offering = Offering.find(params[:id])
  end

  # POST /offerings
  # POST /offerings.json
  def create
    @offering = Offering.new(params[:offering])

    respond_to do |format|
      if @offering.save
        format.html { redirect_to @offering, notice: 'Offering was successfully created.' }
        format.json { render json: @offering, status: :created, location: @offering }
      else
        format.html { render action: "new" }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offerings/1
  # PUT /offerings/1.json
  def update
    @offering = Offering.find(params[:id])

    respond_to do |format|
      if @offering.update_attributes(params[:offering])
        format.html { redirect_to @offering, notice: 'Offering was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offerings/1
  # DELETE /offerings/1.json
  def destroy
    @offering = Offering.find(params[:id])
    @offering.destroy

    respond_to do |format|
      format.html { redirect_to offerings_url }
      format.json { head :no_content }
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      offering = find_by_id(row["id"]) || new
      offering.attributes = row.to_hash.slice(*accessible_attributes)
      offering.save!
    end
  end
end
