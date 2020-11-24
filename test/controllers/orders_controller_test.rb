
require "test_helper"

describe OrdersController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  before do
    # new_params = {product_id: products(:blanket).id, quantity: 3}
    # post order_items_path, params: new_params
    # @new_order = Order.last
  end

  # describe "history" do
  #   it "redirects if no user is logged in" do
  #     @order = orders(:order1)
  #
  #     get order_history_path(@order)
  #
  #     must_respond_with :redirect
  #   end
  #
  #   it "redirects to shopping cart if user searches for current in progress order" do
  #     @current_merchant = merchants(:merchant1)
  #     @order = orders(:order1)
  #     @current_order = orders(:betty)
  #
  #     get order_history_path(@order)
  #
  #     must_respond_with :redirect
  #   end
  # end

  describe "select_status" do
    before do
      @merchant = merchants(:merchant1)
    end

    it "redirects if no user is logged in" do
      get select_status_path(@merchant)

      must_respond_with :redirect
    end

    it "redirects if logged in user is not the right merchant" do
      wrong = merchants(:merchant2)
      perform_login(wrong)

      get select_status_path(@merchant)

      must_respond_with :redirect
    end

    it "responds with success if user is logged in" do
      perform_login(@merchant)

      get select_status_path(@merchant)

      must_respond_with :success
    end
  end

  #LEAVE THIS FOR KAL
  # describe "update" do
  #   before do
  #     @update_params = {
  #         order: {
  #             customer_name: "Sea Wolf",
  #             email_address: "seawolf@gmail.com",
  #             mailing_address: "1234 Happy Town, Seattle, WA",
  #             cc_number: 12345678,
  #             cc_expiration: "12/20",
  #             cc_security_code: "123",
  #             zip_code: "99999",
  #             cart_status: "paid"}
  #     }
  #     new_params = {product_id: products(:blanket).id, quantity: 3}
  #     post order_items_path, params: new_params
  #     @new_order = Order.last
  #   end
  #
  #   it "completes order with valid params when order.cart_status == pending and order.id == session[:order_id]" do
  #     patch order_path(@new_order), params: @update_params
  #     @new_order.reload
  #
  #     expect(@new_order.cart_status).must_equal "paid"
  #     must_respond_with :redirect
  #     must_redirect_to order_path(@new_order)
  #     products(:blanket).reload
  #     expect(products(:blanket).stock).must_equal 18
  #   end
  #
  #   it "re-renders edit page if any order item's quantity is greater than its product's stock" do
  #     products(:blanket).stock = 2
  #     products(:blanket).save
  #
  #     patch order_path(@new_order), params: @update_params
  #     must_respond_with :bad_request
  #     expect(flash[:status]).must_equal :failure
  #     expect(@new_order.status).must_equal "pending"
  #   end
  #
  #   it "will not let user check out if an order item has changed status to inactive" do
  #     products(:blanket).retire
  #     products(:blanket).save
  #     patch order_path(@new_order), params: @update_params
  #     must_respond_with :bad_request
  #   end
  #
  #   it "responds with :unauthorized if order.id != session[:order_id]" do
  #     patch order_path(orders(:a)), params: @update_params
  #     must_respond_with :unauthorized
  #   end
  #
  #   it "will not let user check out when cart status != pending" do
  #     patch order_path(@new_order), params: @update_params
  #     patch order_path(@new_order), params: @update_params
  #     must_respond_with :unauthorized
  #   end
  #
  #   it "responds with :bad_request when order ID is invalid" do
  #     patch order_path(-1), params: @update_params
  #     must_respond_with :bad_request
  #   end
  #
  #   it "responds with :bad_request when cart is empty" do
  #     @new_order.order_items.destroy_all
  #     patch order_path(@new_order), params: @update_params
  #     must_respond_with :bad_request
  #   end
  # end
end
