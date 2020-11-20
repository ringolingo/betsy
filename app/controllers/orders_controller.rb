class OrdersController < ApplicationController
  #skip_before_action :require_login, only: [:history]
  skip_before_action :require_login
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by(id: params[:id])
  end

  def edit

    @order = Order.find_by(id: params[:id])
    redirect_to orders_path and return if @order.nil?
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
