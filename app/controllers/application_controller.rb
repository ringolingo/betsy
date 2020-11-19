class ApplicationController < ActionController::Base

private

  def set_current_order
    @current_user = Order.find_by(id: session[:order_id])
  end

end
