require "test_helper"

describe OrderItem do
  let(:order_item) { order_items(:one) }

  it "can be instantiated" do
    expect(order_item.valid?).must_equal true
  end

  describe "validations" do
    it 'is valid when all fields are present' do
      order_item = order_items(:one)
      result = order_item.valid?

      expect(result).must_equal true
    end

    it 'is invalid with a quantity of zero or less' do
      order_item = order_items(:one)
      order_item.quantity = 0
      result = order_item.valid?

      expect(result).must_equal false
    end

    it 'is valid with a quantity greater than zero' do
      order_item = order_items(:one)
      result = order_item.valid?

      expect(result).must_equal true
    end

    it 'is invalid with a quantity that is not an integer' do
      order_item = order_items(:one)
      order_item.quantity = 1.5
      result = order_item.valid?

      expect(result).must_equal false
    end

    it 'is invalid with a quantity that is not present' do
      order_item = order_items(:one)
      order_item.quantity = nil
      result = order_item.valid?

      expect(result).must_equal false
    end
  end

  describe "relations" do
    it "has a product" do
      item_1 = order_items(:one)

      expect(item_1).must_respond_to :product
      expect(item_1.product).must_be_kind_of Product
    end

    it "has an orders" do
      item_1 = order_items(:one)

      expect(item_1).must_respond_to :order
      expect(item_1.order).must_be_kind_of Order
    end
  end

  describe "custom methods" do
    #ADD TESTS
  end

end
