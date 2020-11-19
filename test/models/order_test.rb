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

    describe 'will be invalid without OrderItem' do

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
end
