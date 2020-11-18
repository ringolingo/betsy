require "test_helper"

describe OrderItem do
  it "can be instantiated" do

  end

  describe "validations" do
    it 'is valid when all fields are present' do
      order_item =
      result = order_item.valid?

      expect(result).must_equal true
    end

    it 'is invalid with a quantity of zero or less' do
      order_item =
      order_item.quantity = 0
      result = order_item.valid?
      expect(result).must_equal false
    end

    it 'is valid with a quantity greater than zero' do

    end

    it 'is invalid with a quantity that is not an integer' do

    end

    it 'is invalid with a quantity that is not present' do

    end
  end

  describe "relations" do
    it "has a product" do
      item_1 =
          expect(item_1).must_respond_to :product
      expect(item_1.product).must_be_kind_of Product
    end

    it "has an order" do
      item_1 =
          expect(item_1).must_respond_to :order
      expect(item_1.order).must_be_kind_of Order
    end
  end

  describe "custom methods" do
    #ADD TESTS
  end

end
