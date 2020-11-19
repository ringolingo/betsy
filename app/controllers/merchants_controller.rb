class MerchantsController < ApplicationController
  skip_before_action :require_login, except: [:current_merchant]

  def index
    @merchants = Merchant.all
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by[uid: auth_hash[:uid],
                                provider: params[:provider]
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

    session[:user_id] = user.id
    redirect_to root_path
  end
end
