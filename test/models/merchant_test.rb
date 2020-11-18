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
    it "can have a product" do
      @merchant = merchants(:merchant1)
      @product = Product.new(merchant: @merchant, name: "stuff")
      @product.save

      expect(@merchant.products.count).must_equal 1
      expect(@merchant.products.first).must_equal @product
    end
  end
end
