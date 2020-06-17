class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:edit, :update, :destroy, :mark_shipped]

  def create
    @orderitem = Orderitem.find_by(order_id: session[:order_id], product_id: params[:product_id])
    # increment quantity if found AND if it's possible to

    if @orderitem
      # we need to check if we CAN increment quantity first before we do:
      selected_item_from_order = @order.orderitems.find_by(product_id: @orderitem.product_id)
      temp_desired_quantity = selected_item_from_order.quantity + params[:quantity].to_i
      result = @orderitem.enough_stock?(temp_desired_quantity)

      if result == false
          flash[:status] = :failure
          # errors.add(params:quantity, "order exceeds in-stock inventory")
          flash[:result_text] = "Can't add another #{@orderitem.product.product_name} to cart; not enough stock"
          flash[:messages] = @orderitem.errors.messages

          return @orderitem
      else
        @orderitem.quantity += params[:quantity].to_i
      end
      
    else
    # create new Orderitem
      @orderitem = Orderitem.new(
        quantity: params[:quantity].to_i,
        product_id: params[:product_id].to_i,
        order_id: @order.id,
        shipped: false
      )
    end

    if @orderitem.save
      # add orderitem to current order
      @order.orderitems << @orderitem
      flash[:status] = :success
      flash[:result_text] = "Added #{ @orderitem.product.product_name } to cart!"
      redirect_to cart_path(session[:order_id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Error adding #{ @orderitem.product.product_name } to cart."
      flash[:messages] = @orderitem.errors.messages
    end
  
    return @orderitem
  end

  def edit ; end
  
  def update
    # if @orderitem.enough_stock?(params[:quantity].to_i) && @orderitem.not_retired?
      if @orderitem.order.status == "pending"
        if @orderitem.update(quantity: params[:orderitem][:quantity])
          flash[:status] = :success
          flash[:result_text] = "Update successful"
          redirect_to cart_path(session[:order_id])
          return
        else
          flash.now[:status] = :failure
          flash.now[:result_text] = "Error updating the item"
          flash.now[:messages] = @orderitem.errors.messages
          redirect_to cart_path(session[:order_id])
          return
        end
      else
        flash[:status] = :failure
        flash[:result_text] = "Cannot update a #{@orderitem.order.status} order"
        redirect_to root_path
      end
    # end
  end

  def destroy
    if @orderitem.order.status == "pending"
      @orderitem.destroy!
      flash[:status] = :success
      flash[:result_text] = "#{@orderitem.product.product_name} was removed from your cart"
      redirect_to cart_path(session[:order_id])
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
