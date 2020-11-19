class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:history]

  def index
    @orders = Order.all
  end

  def update
    result = @current_order.check_stock
    if result.any?
      result.each do |entry|
        #Flash message?
      end

      render :edit, status: :bad_request
      return
    end

    if @current_order.update(order_params)
      @current_order.status = "paid"

      @current_order.save
      session.delete(:order_id)
      @current_order.decrement_stock  #add flash message???

      redirect_to order_path(@current_order)
      return
    else
      render :edit
      return
    end
  end

  def history
    @order = Order.find_by(id: params[:id])

    if @order == @current_order
      redirect_to order_path(@current_order) and return
    elsif @current_merchant.nil?
      flash[:error] = "You must log in to see that page"
      redirect_to merchants_path and return
    end

    @items = @current_merchant.filter_order(@order)
    return @items
  end
end
