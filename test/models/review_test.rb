require "test_helper"

describe Review do
  describe "validations" do
    before do
      @new_review = Review.new(rating: 4, description: "a good product", product_id: 1)
    end

    it "creates a review given a rating, description, and product id" do
      @new_review.save
      expect(@new_review.valid?).must_equal true
    end

    it "does not create a new review without a rating" do
      @new_review.rating = nil
      expect(@new_review.valid?).must_equal false
    end

    it "does not create a new review without a description" do
      @new_review.description = nil
      expect(@new_review.valid?).must_equal false
    end

    it "does not create a new review without a product id" do
      @new_review.product_id = nil
      expect(@new_review.valid?).must_equal false
    end

    it "must have an integer rating" do
      rating = Review.new(rating: 3.2)

      expect(rating.valid?).must_equal false
    end

    it "must have a rating between 1 and 5" do
      low = Review.new(rating: 0)
      high = Review.new(rating: 6)

      expect(low.valid?).must_equal false
      expect(high.valid?).must_equal false
    end

  end

end
