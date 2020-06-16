class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:update, :destroy, :mark_shipped]

  # create a new orderitem
  # add to existing order if order exists; if not, create new order and add this orderitem to it
  def create
    if session[:order_id] && Order.find_by(id: session[:order_id])
      @order = Order.find_by(id: session[:order_id])
    else
      @order = Order.new(status: "pending")
      unless @order.save
        flash[:status] = :failure
        flash[:result_text] = "Couldn't create order, try again later"
        # flash[:messages] = orderitem.errors.messages
        return
      end
      session[:order_id] = @order.id
    end

    # Increase quantity of desired product
    @orderitem = Orderitem.find_by(order_id: session[:order_id], product_id: params[:product_id])
    if @orderitem
      @orderitem.quantity += params[:orderitem][:quantity].to_i
    else
    # need to create new Orderitem
      @orderitem = Orderitem.new(
        quantity: params[:orderitem][:quantity],
        product_id: params[:product_id],
        order_id: @order.id,
        shipped: false
      )
    end

    if @orderitem.save
      flash[:status] = :success
      flash[:result_text] = "Added #{@orderitem.product.product_name} to cart!"
    else
      flash[:status] = :failure
      flash[:result_text] = "Error adding #{@orderitem.product.product_name} to cart."
      flash[:messages] = @orderitem.errors.messages
    end

    # continue shopping at same point or go back to root?
    redirect_to cart_path(id: session[:order_id])
  end
  
  def update
    if @orderitem.order.status == "pending"
      if @orderitem.update(quantity: params[:orderitem][:quantity])
        flash[:status] = :success
        flash[:result_text] = "Update successful"
        redirect_to cart_path
        return
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Error updating the item"
        flash.now[:messages] = @orderitem.errors.messages
        redirect_to cart_path
        return
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot update a #{@orderitem.order.status} order"
      redirect_to root_path
    end
  end

  def destroy
    if @orderitem.order.status == "pending"
      @orderitem.destroy
      flash[:status] = :success
      flash[:result_text] = "#{@orderitem.product.product_name} was removed from your cart"
      redirect_to cart_path(order_id: session[:id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot delete items"
      redirect_to root_path
    end
  end

  def mark_shipped
    if @orderitem.order.status == "paid" && @orderitem.shipped == false
      @orderitem.mark_item_shipped!
      flash[:status] = :success
      flash[:result_text] = "#{ @orderitem.product.product_name } has shipped!"
      # @orderitem.order.mark_as_complete!
      redirect_back fallback_location: root_path
    elsif @orderitem.order.status == "paid" && @orderitem.shipped == true
      flash[:status] = :failure
      flash[:result_text] = "#{ @orderitem.product.product_name } has already shipped."
      redirect_back fallback_location: root_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot perform this action for a #{@orderitem.order.status} order"
      redirect_to root_path
    end
  end

  private
  
  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])
    head :not_found unless @orderitem
  end
end
