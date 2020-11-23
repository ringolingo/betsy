require "test_helper"

describe Order do

  before do
    @order = orders(:betty)
  end

  describe 'validations' do

    it 'is valid when all fields are present' do
      #order_item = OrderItem.create(product_id: 1, order_id: @orders.id)
      expect(@order.valid?).must_equal true
    end

    it 'will be invalid without status' do

      @order.status = nil

      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :status
      expect(@order.errors.messages[:status][0]).must_equal "can't be blank"

    end

    it 'will be invalid with status other than paid or processing' do
      @order.status = 'nope'

      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :status
      expect(@order.errors.messages[:status][0]).must_equal "nope is not a valid status"
    end
  end

  describe 'relationships' do

    it "has many order items" do
      expect(existing_order).must_respond_to :order_items
    end

    it 'OrderItem can add an Order' do
      order_item = OrderItem.create(product: products(:blanket), order: @order)
      expect(order_item.order.name).must_equal "Betty Elms"
    end

    it 'Can access Product through OrderItem' do
      order_item = OrderItem.create(product: products(:blanket), order: @order)
      expect(order_item.order.name).must_equal "Betty Elms"
    end

    end

  describe 'custom methods' do

    describe 'total' do
      it 'will return the total' do
        expect(@order.sub_total).must_equal 19000
      end

      #TODO: edge cases
      it 'will return 0 if nothing if all order items have quantity of 0' do


      end
    end

    describe 'total' do

      it 'will return the total plus taxes and shipping' do
        expect(@order.total(tax: 0.065, shipping: 500)).must_equal 20735
      end
      #TODO: edge cases
      it 'will return 0 if nothing is in the order' do

      end
    end


  end
end
