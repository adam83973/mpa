class OfferingHistoriesController < ApplicationController

  before_action :authorize_employee
  before_action :authorize_admin
  before_action :set_offering_history, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @offering_histories = OfferingHistory.all
    respond_with(@offering_histories)
  end

  def show
    respond_with(@offering_history)
  end

  def new
    @offering_history = OfferingHistory.new
    respond_with(@offering_history)
  end

  def edit
  end

  def create
    @offering_history = OfferingHistory.new(params[:offering_history])
    @offering_history.save
    respond_with(@offering_history)
  end

  def update
    @offering_history.update_attributes(params[:offering_history])
    respond_with(@offering_history)
  end

  def destroy
    @offering_history.destroy
    respond_with(@offering_history)
  end

  private
    def set_offering_history
      @offering_history = OfferingHistory.find(params[:id])
    end
end
