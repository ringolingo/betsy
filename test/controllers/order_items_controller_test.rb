require "test_helper"

describe OrderItemsController do

  let(:order_item_params){
    {
        order_item: {
            quantity: 2
        }
    }
  }

  let(:order_item){
      order_items(:one)
  }
  describe 'destroy' do
    it "can destroy an existing OrderItem" do
      order_item.order.update!(status: 'pending')
      expect{
        delete order_order_item_path(order_item.order, order_item)
      }.must_change "OrderItem.count", -1

      expect(flash[:success]).must_equal "Order item successfully deleted"

      test_order_item = OrderItem.find_by(id: OrderItem.first.id)

      expect(test_order_item).must_be_nil

      must_respond_with :redirect
      #must_redirect_to works_path
    end
  end

  describe 'update' do

    it "can update an existing OrderItem" do

      id = OrderItem.first.id
      expect{
        patch order_order_item_path(id), params: order_item_params
      }.wont_change "OrderItem.count"

      must_respond_with :redirect

      test_order_item = OrderItem.find_by(id: id)
      expect(test_order_item.quantity).must_equal order_item_params[:order_item][:quantity]

      expect(flash[:success]).must_equal "Order item successfully updated"
    end

    it 'will respond with error if quantity is nil' do

      order_item_params[:order_item][:quantity] = nil

      id = OrderItem.first.id
      expect{
        patch order_item_path(id), params: order_item_params
      }.wont_change "OrderItem.count"

      expect(flash[:error]["title"]).must_equal "Error: unable to update cart"
      expect(flash[:error]["errors"][0]).must_equal "quantity: can't be blank - is not a number"

      must_respond_with :bad_request
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

    it 'will not create new OrderItem if product stock is < quantity' do

      order_item_params[:order_item][:quantity] = 666

      expect{
        post product_order_items_path(products(:blanket).id), params: order_item_params
      }.wont_change "OrderItem.count"

      expect(flash[:error]["title"]).must_equal "There's not enough of this item to complete your request"

      must_respond_with :redirect
    end

    it 'will respond with error if quantity is nil' do

      order_item_params[:order_item][:quantity] = nil

      expect{
        post product_order_items_path(products(:blanket).id), params: order_item_params
      }.wont_change "OrderItem.count"

      expect(flash[:error]["title"]).must_equal "Unable to add product to cart"
      expect(flash[:error]["errors"][0]).must_equal "quantity: can't be blank - is not a number"

      must_respond_with :bad_request
    end
  end
end
