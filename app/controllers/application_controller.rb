class ApplicationController < ActionController::Base

  before_action :set_current_order
  before_action :require_login
  before_action :current_merchant



  def find_order
    if params[:order_id]
      @order = Order.find_by(id: params[:order_id])
    elsif params[:id]
      @order = Order.find_by(id: params[:id])
    elsif session[:order_id] && session[:order_id] != nil
      @order = Order.find_by(id: session[:order_id])
    end
    if @order.nil?
      flash.now[:status] = :danger
      flash.now[:result_text] = "Sorry, order not found."
      render 'products/index', status: :bad_request
      return
    end
  end

  def is_this_your_cart?
    if @order.status == "pending" && @order.id != session[:order_id]
      flash.now[:status] = :danger
      flash.now[:result_text] = "You are not authorized to view this pending order."
      render 'products/index', status: :unauthorized
      return
    end
  end

  def still_pending?
    if @order.status != "pending"
      flash.now[:status] = :danger
      flash.now[:result_text] = "Sorry, you cannot modify a checked-out order."
      render 'products/main', status: :unauthorized
      return
    end
  end

  private

  def set_current_order
    @current_order = Order.find_by(id: session[:order_id])
  end

  def current_merchant
    if session[:user_id]
      @current_merchant = Merchant.find_by(id: session[:user_id])
    end
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to do that"
      redirect_to root_path
    end
  end



end
