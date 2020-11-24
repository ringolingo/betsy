class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
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

  private

  def category_params
    params.require(:category).permit(:category)
  end
end
