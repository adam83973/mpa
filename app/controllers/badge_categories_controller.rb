class BadgeCategoriesController < ApplicationController
  before_filter :authorize_admin
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
    @badge_category = BadgeCategory.new(params[:badge_category])
    @badge_category.save
    respond_with(@badge_category)
  end

  def update
    @badge_category.update_attributes(params[:badge_category])
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
end
