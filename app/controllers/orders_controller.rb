class OrdersController < ApplicationController
  # todo -product model made then collab for update order quantity
  # before_action :require_login, only: [:merchant_order]
  before_action :find_order_from_session, only: [:edit, :update, :cart]
  # delete merch order from 6 if not used eventually *****
  before_action :find_order_from_params, only: [:show, :merchant_order, :success]

  # Renders details page for order already paid for (or cancelled?)
  # if we want other redirect behavior, edit later******
  def show ; end

  # Renders payment information form
  def edit ; end

  # Called when user tries to submit payment
  def update
    if @order.update(order_params)

      result = @order.checkout

      if result == true
        flash.now[:result_text] = "(1) Order successfully paid!"
        # redirect_back(fallback_location: root_path)
        # redirect_to order_path(@order.id)
        redirect_to success_path(id: @order.id)
        reset_session
        return
      else
        # Maybe don't sweat testing this else block: 38 - 43
        # render :edit, status: :bad_request
        flash[:result_text] = "Order failed to checkout."
        redirect_back(fallback_location: root_path)
        return
      end

      # redirect_to success_path(session[:order_id])
      # return
    else
      # redirect_to edit_order_path(session[:order_id])
      render :edit
    end
  end

  # Shows cart currently in progress
  def cart ; end

  # Shows confirmation page for recently placed order
  def success ; end

  # deleted view file and route
  # def merchant_order
  #   unless @order.is_order_of(session[:merchant_id]) && @order.status != 'pending'
  #     flash[:status] = :failure
  #     flash[:result_text] = "You do not have access to this page"
  #     redirect_back fallback_location: root_path
  #     return
  #   end
  # end

  private

  def order_params
    params.require(:order).permit(:email, :address, :cc_name, :cc_num, :cvv, :cc_exp, :zip)
  end

  def find_order_from_session
    @order = Order.find_by(id: session[:order_id])
    return head :not_found if @order.nil?
  end

  def find_order_from_params
    @order = Order.find_by(id: params[:id])
    return head :not_found if @order.nil?
  end
end
