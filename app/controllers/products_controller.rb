class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :update, :edit, :destroy]

  def index
    if params[:category_name]
      # NOTE TO SELF DO NOT EVER USE WHERE, FIND_BY IS THE WAY TO GO
      @products = Category.find_by(category_name: params[:category_name]).products
      @collection_name = params[:category_name]
    elsif params[:username]
      @products = Merchant.find_by(username: params[:username]).products
      @collection_name = "Products by #{params[:username]}"
    else
      @products = Product.all
      @collection_name = "all products"
    end
  end

  def show
    if @product.nil?
      flash[:error] = "Product has either been deleted, sold out, or not found."
      head :not_found
      return
    end 
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    if @product.id?
      redirect_to root_path
    else
      render :new
    end

    rescue ActionController::ParameterMissing
      redirect_to new_product_path
  end

  def update
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      redirect_to products_path(@product)
      return
    else
      render :edit
      return
    end
  end

  def edit
    if @product.nil?
      redirect_to products_path(@product)
      return
    end
  end

  def destroy
    if @product.nil?
      redirect_to products_path
      return
    end

    @product.destroy

    redirect_to products_path
    return
  end

  private
  def find_product
    # TODO: need to add case for when product cannot be found, to DRY up code
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:product_name, :price, :description, :photo_url, :stock, :merchant_id)
  end
end
