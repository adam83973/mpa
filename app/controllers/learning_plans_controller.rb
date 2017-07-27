class LearningPlansController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_employee, except: [ :show ]

  before_action :set_learning_plan, only: [:show, :edit, :update, :destroy]

  # GET /learning_plans
  def index
    @learning_plans = LearningPlan.all
  end

  # GET /learning_plans/1
  def show
  end

  # GET /learning_plans/new
  def new
    @learning_plan = LearningPlan.new
    3.times{ @learning_plan.goals.build }
  end

  # GET /learning_plans/1/edit
  def edit
    @learning_plan.goals.build
  end

  # POST /learning_plans
  def create
    @learning_plan = LearningPlan.new(learning_plan_params)

    if @learning_plan.save
      redirect_to learning_plan_path(@learning_plan), notice: 'Learning plan was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /learning_plans/1
  def update
    if @learning_plan.update(learning_plan_params)
      redirect_to learning_plan_path(@learning_plan), notice: 'Learning plan was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /learning_plans/1
  def destroy
    @learning_plan.destroy
    redirect_to learning_plans_url, notice: 'Learning plan was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_learning_plan
      @learning_plan = LearningPlan.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def learning_plan_params
      params.require(:learning_plan).permit(:student_id, :user_id, :grade, :course_id, :learning_plan_issue_id, :notes, :strengths, goals_attributes: [:id, :name])
    end
end
