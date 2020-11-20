class ApplicationController < ActionController::Base

  before_action :set_current_order
  before_action :require_login
  before_action :current_merchant


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

  private

  def set_current_order
    @current_order = Order.find_by(id: session[:order_id])
  end

end
