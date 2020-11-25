
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

  # describe "history" do -- TODO Ringo delete?
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

  # describe "select_status" do -- TODO Ringo delete?
  #   before do
  #     @merchant = merchants(:merchant1)
  #   end

  #   it "redirects if no user is logged in" do
  #     get select_status_path(@merchant)
  #
  #     must_respond_with :redirect
  #   end
  #
  #   it "redirects if logged in user is not the right merchant" do
  #     wrong = merchants(:merchant2)
  #     perform_login(wrong)
  #
  #     get select_status_path(@merchant)
  #
  #     must_respond_with :redirect
  #   end
  #
  #   it "responds with success if user is logged in" do
  #     perform_login(@merchant)
  #
  #     get select_status_path(@merchant)
  #
  #     must_respond_with :success
  #   end
  # end

end
