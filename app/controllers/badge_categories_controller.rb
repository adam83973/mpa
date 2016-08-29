class BadgeCategoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin, except: [:index, :show]
  before_filter :set_badge_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @badge_categories = BadgeCategory.all
    respond_with(@badge_categories)
  end

  def show
    respond_with(@badge_category)
  end

  def new
    @badge_category = BadgeCategory.new
    respond_with(@badge_category)
  end

  def edit
  end

  def create
    @badge_category = BadgeCategory.new(badge_category_params)
    @badge_category.save
    respond_with(@badge_category)
  end

  def update
    @badge_category.update_attributes(badge_category_params)
    respond_with(@badge_category)
  end

  def destroy
    @badge_category.destroy
    respond_with(@badge_category)
  end

  private
    def set_badge_category
      @badge_category = BadgeCategory.find(params[:id])
    end

    def badge_category_params
      params.require(:badge_category).permit(:name, :write_up_required, :parent_can_request, :multiple)
    end
end
