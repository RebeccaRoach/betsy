class OrdersController < ApplicationController
  # todo -product model made then collab for update order quantity
  before_action :require_login, only: [:merchant_order]
  before_action :find_order_from_session, only: [:edit, :update]
  before_action :find_order_from_params, only: [:show, :merchant_order]

  # Find order or display message if cart is empty
  # route triggers 
  def cart
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
      session[:order_id] = @order.id
    else
      flash[:result_text] = "Couldn't create order, try again later"
      flash[:messages] = @order.errors.messages
    end
  end

  #renders payment information form
  # enter payment details, find order_id from session
  def edit; end

  # this is called when user clicks the "checkout" button on cart page
  def update
    # all fields must be valid; validations run on save to db - need extra code for this?
    @order.orderitems.each do |orderitem|
      # check enough_stock from product model***
      if !orderitem.valid?
        flash[:status] = :failure
        flash[:result_text] = "Some items in your cart are no longer available"
        flash[:messages] = orderitem.errors.messages
      end

      if flash[:status] = :failure
        flash[:messages] = order.errors.messages
        return redirect_to cart_path
      end
    end
  end

  # Confirmation page for order : for all statuses ?
  def show
    if @order.id < 0
      head :not_found
    end

    if @order.status == "pending"
      flash[:status] = :failure
      flash[:result_text] = "Your order is being process"
      flash[:messages] = @order.errors.messages
      redirect_to root_path
      return
    elsif @order.status == "paid"
      flash[:status] = :success
      # maybe add result text, maybe not?
      redirect_to order_path(@order.id)
    end
  end

  # we call this method when user submits payment form
  def submit
    result = @order.checkout
    if result
      flash[:result_text] = "Order successfully paid!"
      redirect_to order_path(@order.id)
    else
      render :edit, status: :bad_request
      flash[:status] = :failure
      flash[:messages] = @order.errors.messages
    end
  end

  # need to add route for this to work
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
