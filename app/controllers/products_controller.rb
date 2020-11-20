class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:index]
  before_action :current_merchant, only: [:index]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @products = Product.new
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    binding.pry

    @product = Product.new(product_params)
    @product.merchant_id = session[:user_id]

    if @product.save
      flash[:status] = :success
      flash[:success] = "Successfully created product."

      redirect_to product_path(@product)
      return
    else
      flash.now[:status] = :failure
      flash.now[:error] = "Error. Unable to create product."
      flash.now[:messages] = @product.errors.messages

      render :new
      return
    end
  end

  def update
    @products = Product.find_by(id: params[:id])

    if @products.nil?
      head :not_found
      return
    elsif @products.update(product_params)
      redirect_to product_path(@products.id)
      return
    else
      render :edit
      return
    end
  end

  def destroy
    @products = Product.find_by(id: params[:id])

    if @products.nil?
      head :not_found
      return
    elsif @products.destroy
      redirect_to products_path
      return
    end
  end

  def toggle_for_sale
    @product = Product.find_by(id: params[:id])
    @merchant = @product.merchant
    unless @merchant == @current_merchant
      flash[:error] = "You do not have access to change that"
      redirect_to merchants_path and return
    end

    @product.toggle_for_sale

    redirect_to merchant_path(@merchant) and return
  end

  private

  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_URL, :stock, :merchant_id, :category)
  end

end
