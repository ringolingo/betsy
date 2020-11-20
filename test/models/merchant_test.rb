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
      @merchant = merchants(:merchant1)
      # @product = products(:blanket)
    end

    it "can have a product" do
      # merchant = Merchant.new(username: "grrrr", email: "aaaaargh@gmail.com")
      # merchant.save
      product = Product.create!(merchant: @merchant, name: "a nice thing", category: "sleep aid", description: "it helps you sleep", price: 1000, stock: 20)
      product.save

      expect(@merchant.products.count).must_equal 1
      expect(@merchant.products).must_include product
    end

    it "can have an order" do
      merchant = Merchant.new(username: "grr", email: "aaargh@gmail.com")
      merchant.save
      order = Order.new(status: "paid")
      order.save
      merchant.orders << order

      expect(merchant.orders.count).must_equal 1
      expect(merchant.orders).must_include order
      expect(order.merchants).must_include merchant
    end
  end

  describe "filter_order" do
    before do
      @current_merchant = merchants(:merchant1)
      @merchant2 = merchants(:merchant2)
      @order = orders(:order1)
    end

    it "returns products belonging to logged in merchant" do
      items = @current_merchant.filter_order(@order)

      expect(items).must_include order_items(:oi1)
    end

    it "does not return other merchants' products" do
      items = @current_merchant.filter_order(@order)

      expect(items).wont_include order_items(:oi2)
    end

    it "returns nil if logged in user has no products in order" do
      @current_merchant = merchants(:merchant3)

      items = @current_merchant.filter_order(@order)

      expect(items).must_be_nil
    end
  end
end
