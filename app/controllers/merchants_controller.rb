class MerchantsController < ApplicationController
  # before_action :require_login, except: [:index, :destroy, :create]

  def index
    @merchants = Merchant.all
    @url = "http://thecatapi.com/api/images/get?format=src&type=gif&timestamp="
  end

  def show
    @merchants = Merchant.find_by(id: params[:id])
    @url = "http://thecatapi.com/api/images/get?format=src&type=gif&timestamp="
    if @merchants.nil?
      head :not_found
      return
    end 
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")

    if merchant
      flash[:result_text] = "Returning merchant: #{merchant.username}"  
    else
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:result_text] = "You are logged in as new merchant: #{merchant.username}." 
      else
        flash[:result_text] = "Failure: Could not create new merchant account"
        flash[:messages] = merchant.errors.messages
        return redirect_to root_path
      end 
    end
    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
    return
  end

  def current
    @current_merchant = Merchant.find_by(id: session[:merchant_id])
  end

  private

  # def merchant_params
    
  # end
end
