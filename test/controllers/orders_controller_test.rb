
require "test_helper"

describe OrdersController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  describe "history" do
    it "redirects if no user is logged in" do
      @order = orders(:order1)

      get order_history_path(@order)

      must_respond_with :redirect
    end

    it "redirects to shopping cart if user searches for current in progress order" do
      @current_merchant = merchants(:merchant1)
      @order = orders(:order1)
      @current_order = orders(:betty)

      get order_history_path(@order)

      must_respond_with :redirect
    end
  end
end
