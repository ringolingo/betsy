

require "test_helper"

describe OrderItemsController do

  let(:order_item_params){
    {
        order_item: {
            quantity: 2
        }
    }
  }

  describe 'destroy' do

    it "will respond with redirect when attempting to delete a nonexistant work" do

      post product_order_items_path(products(:blanket).id), params: order_item_params
      order_item = OrderItem.order("created_at").last

      delete order_order_item_path(order_item.order, -1)

      must_respond_with :redirect

      must_redirect_to root_path
    end

    it "can destroy an existing OrderItem" do

      post product_order_items_path(products(:blanket).id), params: order_item_params
      order_item = OrderItem.order("created_at").last

      expect{
        delete order_order_item_path(order_item.order, order_item)
      }.must_change "OrderItem.count", -1

      expect(flash[:success]).must_equal "Product removed from your cart"

      test_order_item = OrderItem.find_by(id: order_item.id)

      expect(test_order_item).must_be_nil

      must_respond_with :redirect
      must_redirect_to order_path(order_item.order)
    end
  end

  describe 'update' do
    before do
      post product_order_items_path(products(:blanket).id), params: {order_item: {quantity: 3}}
      @order_item = OrderItem.order("created_at").last
    end

    it "will respond with redirect when attempting to update a nonexistant work" do
      post product_order_items_path(products(:blanket).id), params: order_item_params
      order_item = OrderItem.order("created_at").last

      patch order_order_item_path(order_item.order, -1), params: order_item_params

      must_respond_with :redirect

      must_redirect_to root_path
    end

    it "can update an existing OrderItem" do


      expect{
        patch order_order_item_path(@order_item.order, @order_item), params: order_item_params
      }.wont_change "OrderItem.count"

      must_respond_with :redirect

      test_order_item = OrderItem.find_by(id: @order_item.id)
      expect(test_order_item.quantity).must_equal order_item_params[:order_item][:quantity]

      expect(flash[:success]).must_equal "Cart successfully updated"
    end

    it 'will respond with error if quantity is nil' do

      order_item_params[:order_item][:quantity] = nil


      expect{
        patch order_order_item_path(@order_item.order, @order_item), params: order_item_params
      }.wont_change "OrderItem.count"

      expect(flash[:error]["title"]).must_equal "Error: unable to update cart"
      expect(flash[:error]["errors"][0]).must_equal "quantity: can't be blank - is not a number"

      must_respond_with :bad_request
    end
  end

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

    it 'will create a new order_item if current_order is paid' do

      post product_order_items_path(products(:blanket).id), params: order_item_params

      order = Order.order("created_at").last
      order.update(status: 'paid')

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

    it 'will increase the number of orders  merchant of product has' do
      expect{
        post product_order_items_path(products(:blanket).id), params: order_item_params
      }.must_change "products(:blanket).merchant.orders.count", 1
    end

  end

  describe "custom methods" do
    describe "ship_order_item" do
      before do
        @order_item = order_items(:oi1)
        @oi_id = @order_item.id
        @merchant = merchants(:merchant1)
        @wrong_merchant = merchants(:merchant2)
      end

      it "responds with success when logged in merchant changes status" do
        perform_login(@merchant)

        patch ship_order_item_path(@order_item)

        updated_oi = OrderItem.find_by(id: @oi_id)
        expect(updated_oi.shipped).must_equal true
      end

      it "responds with redirect when merchant is not logged in" do
        perform_login(@wrong_merchant)
        
        patch ship_order_item_path(@order_item)

        updated_oi = OrderItem.find_by(id: @oi_id)
        expect(updated_oi.shipped).must_equal true
      end
    end
  end
end
