class OrderItemsController < ApplicationController

  def destroy
    redirect_to orders_path and return if @order_item.nil?

    if @order_item.update(order_item_params)
      flash[:success] = "Order item successfully deleted"
      redirect_to orders_path
    else
      flash.now[:error] = "Error: unable to delete order item"
      render orders_path, status: :bad_request
    end

  end

  def update
    redirect_to orders_path and return if @order_item.nil?

    if @order_item.update(order_item_params)
      flash[:success] = "Order item successfully deleted"
      redirect_to orders_path
    else
      flash.now[:error] = "Error: unable to update order item"
      render orders_path, status: :bad_request
    end
  end

  private

  def find_order_item
    @order_item = OrderItem.find_by(id :params[:id].to_i)
  end

  def order_item_params
    return params.require(:order_item).permit(:order_item_id, :order_id, :product_id, :quantity)
  end

end
