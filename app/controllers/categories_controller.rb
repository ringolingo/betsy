class CategoriesController < ApplicationController
  skip_before_action :require_login

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
      flash.now[:warning] = 'Category was not created'
      @category.errors.messages.each do |field, msg|
        flash.now[field] = msg
      end
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:category)
  end
end
