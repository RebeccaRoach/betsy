class OrderitemsController < ApplicationController
  before_action

  # create a new order or add to existing- do we want this?
  def create
    if session[:order_id] && Order.find_by(id: session[:order_id])
      @order = Order.find_by(id: session[:order_id])
    else
      @order = Order.new(status: "pending")
      unless @order.save
        flash[:status] = :failure
        flash[:result_text] = "Couldn't create order, try again later"
        flash[:messages] = orderitem.errors.messages
      end
      session[:order_id] = @order.id
    end

    # Increase quantity of desired product
    @orderitem = Orderitem.find_by(order_id: session[:order_id], product_id: params[:product_id])
    if @orderitem
      @orderitem.quantity += params[:orderitem][:quantity].to_i
    else
      @orderitem = Orderitem.new(
        quantity: params[:orderitem][:quantity],
        product_id: params[:product_id],
        order_id: @order.id,
        shipped: false
      )
    end

    if @orderitem.save
      flash[:status] = :success
      flash[:result_text] = "#{orderitem.product.name} was added to cart"
    else
      flash[:status] = :failure
      flash[:result_text] = "Error adding #{orderitem.product.name} to cart"
      flash[:messages] = @orderitem.errors.messages
    end
    redirect_back fallback_location: root_path
    return
  end

  def edit ; end
  
  # comment here
  def update
    if @orderitem.order.status == "pending"
      if @orderitem.update(quantity: params[:orderitem][:quantity])
        flash[:status] = :success
        flash[:result_text] = "Update sucessful"
        redirect_to cart_path
        return
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Error updating the item"
        flash.now[:messages] = @orderitem.errors.messages
        render :edit, status: :bad_request
        return
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot update a #{@orderitem.order.status} order"
      redirect_to root_path
    end
  end

  # comment here
  def destroy
    if @orderitem.order.status == "pending"
      @orderitem.destroy
      flash[:status] = :success
      flash[:result_text] = "#{@orderitem.product.name} was removed from your cart"
      redirect_to root_path
    end
  end

end
