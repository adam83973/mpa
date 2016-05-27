class LearningPlanGoalsController < ApplicationController
  before_action :set_learning_plan_goal, only: [:show, :edit, :update, :destroy]

  # GET /learning_plan_goals
  def index
    @learning_plan_goals = LearningPlanGoal.all
  end

  # GET /learning_plan_goals/1
  def show
  end

  # GET /learning_plan_goals/new
  def new
    @learning_plan_goal = LearningPlanGoal.new
  end

  # GET /learning_plan_goals/1/edit
  def edit
  end

  # POST /learning_plan_goals
  def create
    @learning_plan_goal = LearningPlanGoal.new(learning_plan_goal_params)

    if @learning_plan_goal.save
      redirect_to @learning_plan_goal, notice: 'Learning plan goal was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /learning_plan_goals/1
  def update
    if @learning_plan_goal.update(learning_plan_goal_params)
      redirect_to @learning_plan_goal, notice: 'Learning plan goal was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /learning_plan_goals/1
  def destroy
    @learning_plan_goal.destroy
    redirect_to learning_plan_goals_url, notice: 'Learning plan goal was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_learning_plan_goal
      @learning_plan_goal = LearningPlanGoal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def learning_plan_goal_params
      params.require(:learning_plan_goal).permit(:name, :completed)
    end
end
