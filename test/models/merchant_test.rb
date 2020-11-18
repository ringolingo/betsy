require "test_helper"

describe Merchant do
  describe "validations" do
    before do
      @new_merchant = Merchant.new(username: "merchant", email: "isell@stuff.com")
    end

    it "creates a merchant given a username and email" do
      @new_merchant.save

      expect(@new_merchant.valid?).must_equal true
    end

    it "does not create a new merchant without a username" do
      @new_merchant.username = nil

      expect(@new_merchant.valid?).must_equal false
    end

    it "does not create a new merchant without an email" do
      @new_merchant.email = nil

      expect(@new_merchant.valid?).must_equal false
    end

    it "does not create a new merchant with a duplicate username" do
      @new_merchant.save

      @repeat = Merchant.new(username: "merchant", email: "ialsosell@stuff.com")

      expect(@repeat.valid?).must_equal false
    end

    it "does not create a new merchant with a duplicate email" do
      @new_merchant.save

      @repeat = Merchant.new(username: "another merchant", email: "isell@stuff.com")

      expect(@repeat.valid?).must_equal false
    end
  end

  describe "relationships" do
    before do
      @merchant = Merchant.new(username: "merchant", email: "merchant@stuff.com")
      # @merchant = merchants(:merchant1)
      @product = Product.new(merchant: @merchant, title: "stuff")
    end

    it "can have a product" do
      @product.save

      expect(@merchant.products.count).must_equal 1
      expect(@merchant.products.first).must_equal @product
    end

    it "destroys the product of a deleted merchant" do
      @product.save

      @merchant.destroy

      expect(@product).must_be_nil
    end
  end
end
