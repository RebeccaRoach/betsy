class OrdersController < ApplicationController
  # todo -product model made then collab for update order quantity
  before_action :require_login, only: [:merchant_order]
  before_action :find_order_from_session, only: [:edit, :update]
  before_action :find_order_from_params, only: [:show, :merchant_order]

  # Find order or display message if cart is empty
  def cart
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Cart is empty"
      redirect_back fallback_location: root_path
      return
    end
  end

  #todo create payment information form
  def edit ; end

  # Process order after payment info has been addded
  def update
    @order.orderitems.each do |oderitem|
      if !orderitem.valid?
        flash[:status] = :failure
        flash[:result_text] = "Some items in your cart are no longer available"
        flash[:messages] = orderitem.errors.messages
      end
      if flash[:status] == :failure
        return redirect_to cart_path
      end
    end

    # Change status and clear cart 
    @order.status = "paid"
    if @order.update(order_params)
      @order.reduce_stock
      session[:order_id] = nil
      redirect_to order_path(@order.id)
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Review and Resubmit"
      flash.now[:messages] = orderitem.errors.messages

      render :edit, status: :bad_request
      return
    end
  end

  # Confirmation page for order
  def show
    if @order.status == "pending"
      flash[:status] = :failure
      flash[:result_text] = "Your order is being process"
      flash[:messages] = @order.errors.messages
      redirect_to root root_path
      return
    end
  end

  # comment here
  def merchant_order
    unless @order.is_order_of(session[:merchant_id]) && @order.status != 'pending'
      flash[:status] = :failure
      flash[:result_text] = "You do not have access to this page"
      redirect_back fallback_location: root_path
      return
    end
  end

  private
  def order_params
    params.require(:order).permit(:email, :mailing_address, :cc_number, :cvv, :expiration, :zip)
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
