class NotesController < ApplicationController
  before_action :authorize_employee, except: [:add_via_post]

  skip_before_action :verify_authenticity_token, only: [:add_via_post]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.json
  def new
    @note = Note.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.json
  def create
    if params[:student_id]
      @notable = Student.find(params[:student_id])
      @student = @notable
    elsif params[:lesson_id]
      @notable = Lesson.find(params[:lesson_id])
      @lesson = @notable
    elsif params[:user_id]
      @notable = User.find(params[:user_id])
      @note_user = @notable
      if params[:note][:opportunity_id]
        @opportunity = Opportunity.find(params[:note][:opportunity_id])
      end
    else
      @opportunity = Opportunity.find(params[:note][:opportunity_id])
    end

    @note = @notable.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render json: @note, status: :created, location: @note }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.json
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(note_params)
        format.html { redirect_to root_url, notice: 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notes/completed
  def completed
    @current_user = current_user
    @note = Note.find(params[:id])

    if @note.notable_type == "Lead"
      @lead = Lead.find(@note.notable_id)
    elsif @note.notable_type == "Opportunity"
      @opportunity = Opportunity.find(@note.notable_id)
    elsif @note.notable_type == "Student"
      @student = Student.find(@note.notable_id)
    elsif @note.notable_type == "User"
      @note_user = User.find(@note.notable_id)
    end

    if @note.update_attributes({completed: true, completed_by: @current_user.id})
      @user_action_needed = [] #user notings are added to this array as well as location leads
      @current_user.notings.includes(:user, :notable).where("completed = ? AND action_date <= ?", false, Date.today).each { |note| @user_action_needed << note }
      @current_user.location.notes.where("completed = ? AND action_date <= ?", false, Date.today).each{ |note| @user_action_needed.push(note) unless @user_action_needed.include?(note)}

      respond_to do |format|
        format.js
      end
    end
  end

  def add_via_post
    params = request.params
    puts params

    head :ok
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
  def note_params
    params.require(:note).permit(:content, :action_date, :completed, :user_id, :location_id, :notable_type, :notable_id, :opportunity_id, :completed_by)
  end
end
