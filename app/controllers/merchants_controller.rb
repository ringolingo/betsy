class MerchantsController < ApplicationController
  skip_before_action :require_login, except: [:current_merchant]

  def index
    @merchants = Merchant.all
  end

  def show
    find_merchant

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
        flash[:error] = "Could not create Merchant account #{merchant.error}"
        return redirect_to root_path
      end
    end

    session[:user_id] = merchant.id
    redirect_to root_path
  end


  private

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end
end
