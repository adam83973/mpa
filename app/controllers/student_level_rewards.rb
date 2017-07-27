class StudentLevelRewardsController < ApplicationController

  def new
    @student_level_reward = StudentLevelReward.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_level_reward }
    end
  end

  def create
    @student_level_reward = StudentLevelReward.new(student_level_reward_params)

    #when a record is added a transaction should be created to track the prize they redeemed
    
  end

  private

    def student_level_reward_params
      params.require(:student_level_reward).permit(:student_id, :occupation_level_id)
    end
end
