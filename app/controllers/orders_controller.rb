class OrdersController < ApplicationController


  before_action :find_order
  before_action :is_this_your_cart
  # before_action :are_products_active?, only: [:update]
  before_action :does_order_have_items?, only: [:update]

  before_action :require_login, only: [:history]

  def index
    @orders = Order.all
  end

  def show
    # @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:status] = :error
      flash[:result_text] = "A problem occurred: Could not find order"
      redirect_to root_path
      return
    end
  end

  def edit
    # @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:status] = :error
      flash[:result_text] = "A problem occurred: Could not find order"
      redirect_to root_path
      return
    end

  end

  def update
    result = @current_order.check_stock
    if result.any?
      result.each do |entry|
        flash.now[:status] = :failure
        flash.now[:result_text] = "#{entry[0]} running low! We currently only have #{entry[1]} left. Please adjust your order."
      end
      render :edit, status: :bad_request
      return
    end

    if @current_order.update(order_params)
      @current_order.status = "paid"
      @current_order.save
      session.delete(:order_id)
      @current_order.decrement_stock
      flash[:status] = :success
      flash[:result_text] = "Order submitted! Enjoy your self-care with vibes."

      redirect_to order_path(@current_order)
      return
    else
      render :edit
      return
    end
  end

  def history
    # @order = Order.find_by(id: params[:id])

    if @order == @current_order
      redirect_to order_path(@current_order) and return
    elsif @current_merchant.nil?
      flash[:error] = "You must log in to see that page"
      redirect_to merchants_path and return
    end

    @items = @current_merchant.filter_order(@order)
    return @items
  end

  def search
    render action: 'show'
  end

  private

  def order_params
    return params.require(:order).permit(:address, :email, :name, :credit_card_number, :expiration, :cvv, :zip_code, :status, :for_sale)
  end
end
