class ProductsController < ApplicationController
  before_filter :authorize_employee
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to product_path, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def update_quantity
    @product = Product.find(params[:product][:id])
    @product.update_attribute :quantity, params[:product][:quantity]

    redirect_to products_path
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def products_by_location
    products = Product.where(location_id: params[:location_id])
    products_list = []

    products.each do |product|
      if params[:credits] == 'true'
        credits = "(#{product.credits})"
      else
        credits = ""
      end

      products_list << [product.id, "#{product.name} #{credits}", product.credits, product.quantity]
    end

    respond_to do |format|
      format.html
      format.json { render json: products_list }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :sku, :price, :credits, :quantity, :location_id, :virtual)
    end
end
