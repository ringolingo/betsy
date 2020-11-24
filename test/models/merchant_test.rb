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
      @product = products(:blanket)
    end

    it "can have a product" do
      expect(@merchant.products.count).must_equal 3
      expect(@merchant.products).must_include @product
    end

    it "can have an order" do
      order = orders(:betty)
      @merchant.orders << order

      expect(@merchant.orders).must_include order
      expect(order.merchants).must_include @merchant
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

  describe "sort_products" do
    before do
      @merchant = merchants(:merchant2)

      @sort = @merchant.sort_products
    end

    it "puts active products before retired products" do
      expect(@sort.last).must_equal products(:product2)
    end

    it "puts newer products before older products" do
      expect(@sort.first).must_equal products(:product4)
    end

    it "returns nil if merchant has no products" do
      none_merchant = merchants(:merchant3)

      sort = none_merchant.sort_products

      expect(sort).must_be_nil
    end

    it "returns all products" do
      count = @merchant.products.size

      expect(@sort.size).must_equal count
    end
  end

  describe "total_revenue" do
    it "correctly returns total revenue for all of a merchant's orders" do
      merchant = merchants(:merchant2)

      expect(merchant.total_revenue).must_equal 11198
    end

    it "correctly totals revenue only for orders with specified status" do
      merchant = merchants(:merchant2)
      status = "pending"

      expect(merchant.total_revenue(status)).must_equal 4000
    end

    it "returns 0 if merchant has no orders" do
      merchant = merchants(:merchant3)

      expect(merchant.total_revenue).must_equal 0
    end

    it "returns 0 if merchant has no orders of requested status" do
      merchant = merchants(:merchant1)
      status = "pending"

      expect(merchant.total_revenue(status)).must_equal 0
    end
  end
end
