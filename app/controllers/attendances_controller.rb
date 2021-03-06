class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_employee
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  # GET /attendances
  def index
    @attendances = Attendance.all
  end

  # GET /attendances/1
  def show
  end

  # GET /attendances/new
  def new
    @attendance = Attendance.new
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances
  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save!
      @student = @attendance.student

      if class_session.in_session?
        add_student_to_class
      end

      respond_to do |format|
        format.js
        format.html {redirect_to student_path(@student), notice: "Attendance added"}
      end
    else
      render :new
    end
  end

  # PATCH/PUT /attendances/1
  def update
    if @attendance.update(attendance_params)
      redirect_to @attendance, notice: 'Attendance was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /attendances/1
  def destroy
    @attendance.destroy
    redirect_to attendances_url, notice: 'Attendance was successfully destroyed.'
  end

  private
    def add_student_to_class
      if class_session.in_session?
       class_session.add_student(@student)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def attendance_params
      params.require(:attendance).permit(:student_id, :experience_point_id, :date, :offering_id, :user_id, :week)
    end
end
