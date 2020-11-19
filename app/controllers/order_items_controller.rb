class OrderItemsController < ApplicationController

  before_action :find_order_item

  def create

    product = Product.find_by(id: params[:id])

    unless @order
      order = Order.create(status: "pending")

      session[:order_id] = order.id


    end

  end

  def destroy
    redirect_to orders_path and return if @order_item.nil?

    if @order_item.update(order_item_params)
      flash[:success] = "Order item successfully deleted"
      redirect_to orders_path
    else
      flash.now[:error] = "Error: unable to delete orders item"
      render orders_path, status: :bad_request
    end

  end

  def update

    redirect_to orders_path and return if @order_item.nil?
    update = @order_item.update(order_item_params)
    if update
      flash[:success] = "Order item successfully updated"
      redirect_to orders_path
    else
      flash.now[:error] = "Error: unable to update orders item"
      redirect_to orders_path
      #render orders_url, status: :bad_request
    end
  end

  private

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id].to_i)
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end

end
