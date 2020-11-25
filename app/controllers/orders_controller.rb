class OrdersController < ApplicationController
  before_action :find_order, except: [:find]
  before_action :is_this_your_cart?, except: [:find]
  before_action :are_products_active?, only: [:update]
  before_action :still_pending?, except: [:show, :find, :search]
  before_action :does_order_have_items?, only: [:update]

  # before_action :require_login, only: [:history]

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

    params[:order][:status] = "paid"

    if @current_order.update(order_params)
      # @current_order.status = "paid"
      # @current_order.save

      @current_order.decrement_stock
      flash[:status] = :success
      flash[:result_text] = "Order submitted! Enjoy your self-care with vibes."

      redirect_to order_path(@current_order)
      return
    else
      #render with bad request?
      flash[:error] = error_flash("Unable to complete order",  @current_order.errors)
      redirect_to edit_order_path(@current_order) and return
    end
  end

  def search
    render action: 'show'
  end

  # def select_status(status: all) -- TODO Ringo - delete?
  #   @merchant = Merchant.find_by(id: params[:id])
  #   unless @merchant == @current_merchant
  #     redirect_to merchant_path(@merchant) and return
  #   end
  #
  #   return Order.select_status(status: status, merchant: @merchant)
  # end

  private

  def does_order_have_items?
    if @order.order_items.empty?
      flash.now[:status] = :danger
      flash.now[:result_text] = "This order has no items to check out."
      render 'products/main', status: :bad_request
      return
    end
  end

  def order_params
    return params.require(:order).permit(:address, :email, :name, :credit_card_number, :expiration_date, :cvv, :zip_code, :status, :for_sale)
  end
end
