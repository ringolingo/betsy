require "test_helper"
  describe ReviewsController do


    describe "new" do
      it "gets a from for a new product review page" do
        # get new_product_review_path(products(:product1).id)
        #
        # must_equal :success
      end
    end

    describe "create" do
      # before do
      #   @review = {review: {rating: 3, review: "a very solid review"} }
      # end

      it "creates a new review" do
        # expect{
        #   post product_reviews_path(products(:product1).id), params: @review
        # }.must_change "Review.count", 1
        #
        # must_redirect_to product_path(products(:product1).id)
        # new_review = Review.find_by(product_id: products(:product1).id, review: "a very solid review")
        # expect(new_review.rating).must_equal @review[:review][:rating]
      end

      it "doesn't create a review for a product that doesn't exist" do

      end
    end
  end
