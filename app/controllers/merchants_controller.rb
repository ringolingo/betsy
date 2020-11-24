class MerchantsController < ApplicationController
  before_action :require_login, only: [:logout]
  before_action :find_merchant, only: [:show, :edit, :update]

  def index
    @merchants = Merchant.all
  end

  def show
    if @merchant.nil?
      flash[:error] = "No such person"
      redirect_to merchants_path and return
    end
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid],
                                  provider: params[:provider])
    if merchant # Merchant Exists
      flash[:notice] = "Existing Merchant #{merchant.username} is logged in."
    else
      # Merchant does not exist yet (new merhcant)
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:success] = "Logged in as new Merchant  #{merchant.username}"
      else
        flash[:error] = error_flash("Could not create Merchant account", merchant.errors)
        return redirect_to root_path
      end
    end

    session[:user_id] = merchant.id
    redirect_to root_path
  end

  def edit
    if @merchant.nil?
      flash[:status] = :danger
      flash[:result_text] = "Sorry, merchant not found."
      redirect_to merchants_path and return
    elsif @merchant != @current_merchant
      flash[:error] = error_flash("You must log in to edit your page.")
      redirect_to merchants_path and return
    end
  end

  def update
    if @merchant.nil?
      flash[:status] = :danger
      flash[:result_text] = "Sorry, merchant not found."
      redirect_to merchants_path and return
    elsif @merchant != @current_merchant
      flash[:error] = error_flash("You must log in to edit your page")
      redirect_to merchants_path and return
    end

    if @merchant.update(merchant_params)
      redirect_to merchant_path(@merchant) and return
    else
      render :edit and return
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end

  private

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end

  def merchant_params
    params.require(:merchant).permit(:username, :email, :description, :uid, :provider, :avatar)
  end
end
