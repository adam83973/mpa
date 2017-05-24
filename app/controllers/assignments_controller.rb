class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_employee, except: :show
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  # GET /assignments
  def index
    if params[:student_id]
      @student = Student.find(params[:student_id])
      @assignments = @student.assignments
    else
      @assignments = Assignment.all
    end
  end

  # GET /assignments/1
  def show
  end

  # GET /assignments/new
  def new
    @offerings = Offering.order(:course_id, :location_id, :day_number).all
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        if class_session && class_session.in_session?
          format.html { redirect_to root_url, notice: 'Assignment was successfully created.' }
        else
          format.html { redirect_to student_path(@assignment.student), notice: 'Assignment was added.' }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  def update
    if @assignment.update(assignment_params)
      redirect_to student_path(@assignment.student), notice: 'Assignment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /assignments/1
  def destroy
    @assignment.destroy
    redirect_to assignments_url, notice: 'Assignment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def assignment_params
      params.require(:assignment).permit(:student_id, :score, :corrected, :user_id, :week, :offering_id, :comment, :experience_point_id, :course_id)
    end
end
