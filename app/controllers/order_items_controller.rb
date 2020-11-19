class OrderItemsController < ApplicationController

  before_action :find_order_item

  def create

    #check if quantity is > stock

    product = Product.find_by(id: params[:product_id])

    save_order = true

    if @current_order.nil?

      order = Order.new(status: "pending")

      save_order = order.save

      session[:order_id] = order.id

      set_current_order
    end

    order_item = OrderItem.new(order: @current_order, product: product, quantity: params[:order_item][:quantity])

    save_order_item = order_item.save

    if(save_order && save_order_item)
      flash[:success] = "Item added to cart!"
      redirect_to orders_path
    else
      flash[:error] = "Unable to add item"
      render "orders/index", status: :bad_request
    end
  end

  def destroy
    redirect_to orders_path and return if @order_item.nil?

    if @order_item.destroy
      flash[:success] = "Order item successfully deleted"
      redirect_to orders_path
    else
      flash.now[:error] = "Error: unable to delete orders item"
      render "orders/index", status: :bad_request
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
      render "orders/index", status: :bad_request
      #render "order/#{@current_order.id}/show", status: :bad_request
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
