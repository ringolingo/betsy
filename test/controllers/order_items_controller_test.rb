require "test_helper"

describe OrderItemsController do

  let(:order_item_params){
    {
        order_item: {
            quantity: 10
        }
    }
  }
  describe 'destroy' do
    it "can destroy an existing OrderItem" do

      id = OrderItem.first.id
      expect{
        delete order_item_path(id)
      }.must_change "OrderItem.count", -1

      expect(flash[:success]).must_equal "Order item successfully deleted"

      test_order_item = OrderItem.find_by(id: id)

      expect(test_order_item).must_be_nil

      must_respond_with :redirect
      #must_redirect_to works_path
    end
  end

  describe 'update' do

    it "can update an existing OrderItem" do

      id = OrderItem.first.id
      expect{
        patch order_item_path(id), params: order_item_params
      }.wont_change "OrderItem.count"

      must_respond_with :redirect

      test_order_item = OrderItem.find_by(id: id)
      expect(test_order_item.quantity).must_equal order_item_params[:order_item][:quantity]

      expect(flash[:success]).must_equal "Order item successfully updated"
    end
  end

  #add edge case
  describe 'create' do

    it 'will create a new order if nothing is in cart' do

      expect{
        post product_order_items_path(products(:blanket).id), params: order_item_params
      }.must_change "Order.count", 1

    end

    it 'will create a new order_item if nothing is in cart' do

      expect{
        post product_order_items_path(products(:blanket).id), params: order_item_params
      }.must_change "OrderItem.count", 1

      new_order_item = OrderItem.order("created_at").last

      expect(new_order_item.quantity).must_equal order_item_params[:order_item][:quantity]

      expect(flash[:success]).must_equal "Item added to cart!"

      must_respond_with :redirect


    end
  end
end
