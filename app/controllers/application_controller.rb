class ApplicationController < ActionController::Base
before_action :set_current_order

private

  def set_current_order
    @current_order = Order.find_by(id: session[:order_id])
  end

end
