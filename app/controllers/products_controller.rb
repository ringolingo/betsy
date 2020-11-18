class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def show
    @products = Product.find_by(id: params[:id])

    if @products.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @products = Product.new
  end

  def update
    @products = Passenger.find_by(id: params[:id])

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


  private

  def product_params
    return params.require(:product).permit(:id, :name, :category, :description, :price, :photo_url, :stock)
  end

end
