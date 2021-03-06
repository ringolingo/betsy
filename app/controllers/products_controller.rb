class ProductsController < ApplicationController

  before_action :require_login, except: [:index, :show]
  before_action :find_product, only: [:show, :edit, :update, :destroy, :toggle_for_sale]

  def index
    @products = Product.all
    @available_products = Product.where(for_sale: true)
    @category = Category.find_by(id: params[:category_id])

  end

  def show
    if @product.nil?
      redirect_to products_path
      return
    end
    @reviews = Review.where(product: @product)
  end

  def new
    @products = Product.new
  end

  def create
    # auth_hash = request.env["omniauth.auth"]
    @product = Product.new(product_params)
    # params[:product][:category_ids].filter{|category_id| !category_id.empty?}.each{|category_id| @product.categories << Category.find_by(id: category_id)}
    @product.merchant_id = session[:user_id]

    if @product.save
      flash[:status] = :success
      flash[:success] = "Successfully created product."

      redirect_to product_path(@product)
      return
    else
      flash.now[:error] = error_flash("Error. Unable to create product.", @product.errors)
      render :new
      return
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:error] = error_flash("No such product")
      redirect_to products_path and return
    elsif @product.merchant =! @current_merchant
      flash[:error] = error_flash("You must log in to edit this product ")
      redirect_to merchants_path and return
    end
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    elsif @product.merchant != @current_merchant
      flash[:error] = error_flash("You do not have access to change that")
      redirect_to merchants_path and return
    elsif @product.update(product_params)

      redirect_to product_path(@product.id)
      return
    else
      render :edit
      return
    end
  end

  def destroy
    if @product.nil?
      head :not_found
      return
    elsif @product.destroy
      redirect_to products_path
      return
    end
  end

  def toggle_for_sale
    @merchant = @product.merchant
    unless @merchant == @current_merchant
      flash[:error] = error_flash("You do not have access to change that")
      redirect_to merchants_path and return
    end

    @product.toggle_for_sale

    redirect_to merchant_path(@merchant) and return
  end

  def category
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      flash[:warning] = "Category is invalid"
      redirect_to root_path
    end
    @products = Product.by_category(params[:id])
    @available_products = Product.by_category(params[:id])
  end

  private

  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_url, :stock, :merchant_id, :for_sale, category_ids: [] )
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end


end
