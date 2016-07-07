class LearningPlanIssuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee, except: [ :show ]

  before_action :set_learning_plan_issue, only: [:show, :edit, :update, :destroy]

  # GET /learning_plan_issues
  def index
    @learning_plan_issues = LearningPlanIssue.all
  end

  # GET /learning_plan_issues/1
  def show
  end

  # GET /learning_plan_issues/new
  def new
    @learning_plan_issue = LearningPlanIssue.new
  end

  # GET /learning_plan_issues/1/edit
  def edit
  end

  # POST /learning_plan_issues
  def create
    @learning_plan_issue = LearningPlanIssue.new(learning_plan_issue_params)

    if @learning_plan_issue.save
      redirect_to @learning_plan_issue, notice: 'Learning plan issue was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /learning_plan_issues/1
  def update
    if @learning_plan_issue.update(learning_plan_issue_params)
      redirect_to @learning_plan_issue, notice: 'Learning plan issue was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /learning_plan_issues/1
  def destroy
    @learning_plan_issue.destroy
    redirect_to learning_plan_issues_url, notice: 'Learning plan issue was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_learning_plan_issue
      @learning_plan_issue = LearningPlanIssue.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def learning_plan_issue_params
      params.require(:learning_plan_issue).permit(:title)
    end
end
