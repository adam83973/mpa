class IssuesController < ApplicationController
  before_action :authorize_employee
  before_action :authorize_admin, only: [:destroy, :edit]
  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.includes(:user).all
    @open_issues = Issue.where("resolved = ?", false).includes(:user).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    set_issue

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/new
  # GET /issues/new.json
  def new
    @issue = Issue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/1/edit
  def edit
    @issue = Issue.find(params[:id])
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        IssueMailer.issue_notification(@issue).deliver
        IssueMailer.issue_submission_notification(@issue).deliver
        format.html { redirect_to root_url, notice: 'Issue was successfully created.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /issues/1
  # PUT /issues/1.json
  def update
    set_issue

    respond_to do |format|
      if @issue.update_attributes(issue_params)
        if @issue.resolved? && @issue.status == 4
          IssueMailer.issue_closed_notification(@issue).deliver
        end
        format.html { redirect_to issues_path, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    set_issue
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end

  def resolved
    set_issue

    if @issue.update_attribute :status, 4
      redirect_to issues_path, notice: 'Issue was marked as closed.'
    else
      redirect_to issues_path, warning: 'Something went wrong and issue was not closed.'
    end
  end

  private
    def issue_params
      params.require(:issue).permit(:name, :priority, :resolved, :status, :summary, :user_id)
    end

    def set_issue
      @issue = Issue.find(params[:id])
    end
end
