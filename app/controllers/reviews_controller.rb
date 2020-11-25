class ReviewsController < ApplicationController

  def index
    if params[:product_id]
      product = Product.find_by(id: params[:product_id])
      @reviews = product.reviews.new

    else
      @reviews = Review.all
    end

  end

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new(product: @product)
  end

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(review_params)
    @review.product = @product

    if @product.merchant_id == session[:user_id]
      flash[:warning] = "Oops! You can't review your own product."
      redirect_to products_path
    elsif
    @review.save
      redirect_to @product
    else
      flash.now[:warning] = "Please complete all review fields."
      render :new
    end

  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: "Deleted!" }
    end
  end

  private
  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :description)
  end
end