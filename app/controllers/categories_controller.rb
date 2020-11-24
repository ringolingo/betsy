class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
    if @category.nil?
      redirect_to categories_path
      return
    end
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = 'You have made a new category.'
      redirect_to categories_path
    else
      flash[:error] = error_flash('Category was not created', @category.errors)
      render :new, status: :bad_request
    end
  end

  def edit
    if @category.nil?
      flash[:error] = "No such category"
      redirect_to categorys_path and return
    elsif @category.merchant =! @current_merchant
      flash[:error] = "You must log in to edit this category "
      redirect_to merchants_path and return
    end
  end

  def update
    if @category.nil?
      head :not_found
      return
    elsif @category.update(category_params)
      redirect_to category_path(@category.id)
      return
    else
      render :edit
      return
    end
  end

  def destroy
    if @category.nil?
      head :not_found
      return
    elsif @category.destroy
      redirect_to category_path
      return
    end
  end

  private

  def category_params
    params.require(:category).permit(:category)
  end
end
