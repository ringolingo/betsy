require "test_helper"

describe CategoriesController do

  before do
    @category = categories(:bedding)
    @cat_params = {
        category: {
            category: "pillows"
        }
    }
  end

  describe "show" do
    it "responds with success when showing an existing category" do
      get category_path(@category)

      must_respond_with :success
    end

    it "redirects for an invalid category id" do

      get category_path(-1)

      must_respond_with :redirect
    end
  end

  describe "create" do
    it 'will create a new category' do
      expect{
        post categories_path, params: @cat_params
      }.must_change "Category.count", 1

      new_cat = Category.order("created_at").last

      expect(new_cat.category).must_equal @cat_params[:category][:category]

      expect(flash[:success]).must_equal 'You have made a new category.'

      must_respond_with :redirect

    end

    it 'will cause error if category is blank' do

      @cat_params[:category][:category] = nil

      expect{
        post categories_path, params: @cat_params
      }.wont_change "Category.count"

      new_cat = Category.order("created_at").last

      expect(flash[:error]["title"]).must_equal "Category was not created"
      expect(flash[:error]["errors"][0]).must_equal "category: can't be blank"

      must_respond_with :bad_request

    end
  end

  describe 'new' do
    it 'can get new category page' do
      get new_category_path

      must_respond_with :success
    end
  end

end
