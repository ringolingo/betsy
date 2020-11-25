class OrderItemsController < ApplicationController

  before_action :find_order, except: [:create, :ship_order_item]
  before_action :is_this_your_cart?, except: [:create, :ship_order_item]
  before_action :still_pending?, except: [:create, :ship_order_item]
  before_action :find_order_item, except: :create


  def create

    product = Product.find_by(id: params[:product_id])

    if params[:order_item][:quantity].to_i > product.stock
      flash[:error] = error_flash("There's not enough of this item to complete your request")
      redirect_to product_path(product) and return
    end

    save_order = true


    if @current_order.nil? || @current_order.status == 'paid'

      order = Order.new(status: "pending")

      save_order = order.save

      session[:order_id] = order.id

      set_current_order
    end

    order_item = OrderItem.new(order: @current_order, product: product, quantity: params[:order_item][:quantity])

    save_order_item = order_item.save

    merchant = order_item.product.merchant
    merchant.orders << @current_order

    if(save_order && save_order_item)
      flash[:success] = "Item added to cart!"
      redirect_to order_path(@current_order)
    else
      flash[:error] = error_flash("Unable to add product to cart",  order_item.errors)
      render "orders/index", status: :bad_request
    end
  end


  def destroy
    redirect_to root_path and return if @order_item.nil?

    if @order_item.destroy
      flash[:success] = "Product removed from your cart"

      # checks if this is the merchant's only product in this order
      # if so, removes merchant from order
      merchant = @order_item.product.merchant
      merchant_products = 0
      @order.order_items.each do |item|
        if item.product.merchant == merchant
          merchant_products += 1
        end
      end
      @order.merchants.delete(merchant) unless merchant_products > 0

     redirect_to order_path(@order_item.order)
    else
      flash[:error] = error_flash("Unable to remove product from cart")
      render "homepages/index", status: :bad_request
    end

  end

  def update
    redirect_to root_path and return if @order_item.nil?

    update = @order_item.update(order_item_params)

    if update
      flash[:success] = "Cart successfully updated"
      redirect_to order_path(@order_item.order)
    else
      flash.now[:error] = error_flash("Error: unable to update cart", @order_item.errors)
      render "homepages/index", status: :bad_request
    end
  end

  def ship_order_item
    unless @order_item.order.merchants.include?(@current_merchant)
      flash.now[:status] = :danger
      flash.now[:result_text] = "You must log in to perform that action"
      redirect_to merchants_path, status: :unauthorized
    end

    @order_item.mark_as_shipped
    redirect_to merchant_path(@current_merchant)
  end

  private

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id].to_i)
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end

end
