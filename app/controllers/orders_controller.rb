class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by(id: params[:id])
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
end
