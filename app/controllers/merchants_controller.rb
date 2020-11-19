class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])

    if @merchant.nil?
      flash[:error] = "No such person"
      redirect_to merchants_path and return
    end
  end
end
