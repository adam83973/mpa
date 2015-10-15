class BadgeModulesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee, except: [ :show ]
  before_filter :authorize_admin, except: [:index, :show]
  before_filter :set_badge_module, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @badge_modules = BadgeModule.all
    respond_with(@badge_modules)
  end

  def show
    respond_with(@badge_module)
  end

  def new
    @badge_module = BadgeModule.new
    respond_with(@badge_module)
  end

  def edit
  end

  def create
    @badge_module = BadgeModule.new(params[:badge_module])
    @badge_module.save
    respond_with(@badge_module)
  end

  def update
    @badge_module.update_attributes(params[:badge_module])
    respond_with(@badge_module)
  end

  def destroy
    @badge_module.destroy
    respond_with(@badge_module)
  end

  private
    def set_badge_module
      @badge_module = BadgeModule.find(params[:id])
    end
end
