class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
    @products = @products.search_by_name(params[:search_name])
    @products = @products.search_by_category(params[:search_category])
    @products = @products.search_by_sku(params[:search_sku])

    case params[:stock_filter]
    when "in_stock"
      @products = @products.in_stock
    when "out_of_stock"
      @products = @products.out_of_stock
    end

    case params[:status_filter]
    when "active"
      @products = @products.active
    when "inactive"
      @products = @products.inactive
    end

    @products = @products.order(:name)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: '製品が正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: '製品が正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: '製品が正常に削除されました。'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :sku, :category, :stock_quantity, :is_active)
  end
end
