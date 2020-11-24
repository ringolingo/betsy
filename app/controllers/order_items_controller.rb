class OrderItemsController < ApplicationController

  before_action :find_order, except: :create
  before_action :is_this_your_cart?, except: :create
  before_action :still_pending?, except: :create
  before_action :find_order_item, except: :create
  before_action :are_products_active?, except: [:destroy, :create]
  before_action :find_product, only: :create
  before_action :available_product?, only: :create,
  before_action :validate_quantity, only: [:create, :update]

  before_action :find_order_item

  def create

    product = Product.find_by(id: params[:product_id])


    if params[:order_item][:quantity].to_i > product.stock
      flash[:error] = error_flash("There's not enough of this item to complete your request")
      redirect_to product_path(product) and return
    end

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
      redirect_to order_path(@current_order)
    else
      flash[:error] = error_flash("Unable to add product to cart",  order_item.errors)
      render "orders/index", status: :bad_request
    end
  end

  def edit
    redirect_to orders_path and return if @order_item.nil?
  end

  def destroy
    redirect_to orders_path and return if @order_item.nil?

    if @order_item.destroy
      flash[:success] = "Order item successfully deleted"
     redirect_to order_path(@order_item.order)
    else
      flash[:error] = error_flash("Unable to remove product from cart")
      render "homepages/index", status: :bad_request
    end

  end

  def update
    #
    # redirect_to orders_path and return if @order_item.nil?
    #
    # update = @order_item.update(order_item_params)
    #
    # if update
    #   flash[:success] = "Order item successfully updated"
    #   redirect_to order_path(@order_item.order)
    # else
    #   flash.now[:error] = error_flash("Error: unable to update cart", @order_item.errors)
    #   render "homepages/index", status: :bad_request
    # end
    @order_item.quantity = params[:new_quantity]
    @order_item.save
    flash[:status] = :success
    flash[:result_text] = "Quantity updated!"
    redirect_to order_path(session[:order_id])
  end

  private

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id].to_i)
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end

  def validate_quantity
    if params[:quantity] && params[:quantity].to_i < 1 || params[:new_quantity] && params[:new_quantity].to_i < 1
      flash.now[:status] = :danger
      flash.now[:result_text] = "Please add more quantity."
      render 'products/main', status: :bad_request
      return
    end
  end

end
