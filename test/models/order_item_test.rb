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
    describe "mark_as_shipped" do
      before do
        @paid_item = order_items(:oi1)
        @pending_item = order_items(:oi2)
      end

      it "changes order item in a paid order to shipped" do
        @paid_item.mark_as_shipped

        expect(@paid_item.shipped).must_equal true
      end

      it "does nothing if order status is not paid" do
        @pending_item.mark_as_shipped

        expect(@pending_item.shipped).must_equal false
      end
    end

    describe "line_item_total" do
      it "returns item price times number of items in order" do
        # order = orders(:order2)
        item = order_items(:oi2)

        expect(item.line_item_total).must_equal 4000
      end

      it "returns zero if no quantity" do
        item = order_items(:oi3)

        expect(item.line_item_total).must_equal 0
      end
    end
  end
end
