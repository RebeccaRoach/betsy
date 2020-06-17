require "test_helper"

describe OrderitemsController do
  let(:existing_orderitem) { orderitems(:rxbar) }

  let(:update_hash) {
    {
      quantity: 1
    }
  }

  describe "create" do

    # Reasonable to check set_current_order here and one other place
    it "creates an order automatically" do
      post product_orderitems_path(products(:snow_pass).id), params: update_hash

      expect(session[:order_id]).wont_be_nil
      expect(session[:order_id]).must_equal Order.last.id
    end

    it "can create a new orderitem with valid data" do
      before_count = Orderitem.count

      item_params = {
        quantity: 3,
        shipped: false
      }

      post product_orderitems_path(products(:discover).id), params: item_params

      expect(session[:order_id]).wont_be_nil
      expect(Orderitem.count).must_equal before_count + 1

      last_orderitem = Orderitem.last
      expect(last_orderitem.order.id).must_equal session[:order_id]
      expect(last_orderitem.order.orderitems.count).must_equal 1
      expect(last_orderitem.product).must_equal products(:discover)
      must_respond_with :redirect
      must_redirect_to cart_path(last_orderitem.order)
    end

    it "can increment the quantity of orderitem already in an order" do
      before_count_orderitem = Orderitem.count
      
      params = {
        quantity: 1,
        shipped: false
      }

      post product_orderitems_path(products(:snow_pass).id), params: params
   
    # does NOT create new orderitem if product already added to order
      post product_orderitems_path(products(:snow_pass).id), params: params
      post product_orderitems_path(products(:snow_pass).id), params: params
  
      expect(Orderitem.count).must_equal before_count_orderitem + 1
      expect(Orderitem.last.quantity).must_equal 3
    end

    # THIS is the one failure case test for the controller:
    it "does something if the product is out of stock????" do
      # create product with 0 stock
      # expect create post will have correct error behavior
      # should not create orderitem (check same count)
    end
  end

  describe "update" do
    it "succeeds for valid data and an existing orderitem" do
      expect {
        patch orderitem_path(existing_orderitem), params: update_hash
      }.wont_change "Orderitem.count"
      
      updated_item = Orderitem.find_by(id: existing_orderitem.id)

      expect(updated_item.quantity).must_equal 1
      must_respond_with :redirect
      must_redirect_to cart_path(session[:order_id])
    end

    it "redirects to cart path without updating when given bad data" do
      bogus_update_hash = {
        quantity: -1
      }

      expect {
        patch orderitem_path(existing_orderitem), params: bogus_update_hash
      }.wont_change "Orderitem.count"

      must_respond_with :redirect
      must_redirect_to cart_path(session[:order_id])
    end

    it "fails to update when status is not pending, and redirects to root_path" do
      before_quantity = existing_orderitem.quantity
      existing_orderitem.order.update!(status: "complete")

      valid_params = {
          quantity: 1
      }

      expect {
        patch orderitem_path(existing_orderitem), params: valid_params
      }.wont_change "Orderitem.count"

      expect(existing_orderitem.quantity).must_equal before_quantity

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "responds with 404 when orderitem does not exist" do
      orderitem = orderitems(:rxbar)
      orderitem.destroy!
      patch orderitem_path(orderitem), params: update_hash
      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "deletes item for existing orderitem with pending status, and redirects" do
      before_count = Orderitem.count

      delete orderitem_path(existing_orderitem.id)

      expect(Orderitem.count).must_equal before_count - 1
      must_redirect_to cart_path(session[:order_id])
    end

    it "fails to delete existing orderitem without pending order status, and redirects" do
      before_count = Orderitem.count
      existing_orderitem.order.status = "complete"
      existing_orderitem.order.save!

      delete orderitem_path(existing_orderitem.id)

      expect(Orderitem.count).must_equal before_count
      must_redirect_to root_path
    end

    it "responds with 404 when orderitem does not exist" do
      orderitem = orderitems(:rxbar)
      orderitem.destroy!
      delete orderitem_path(orderitem)
      must_respond_with :not_found
    end
  end

  describe "mark_shipped" do
    it "can correctly change shipped status for existing orderitem" do
    end

    # it "responds with 404 when orderitem does not exist" do
    #   orderitem = orderitems(:rxbar)
    #   orderitem.destroy!
    #   # change to right path::: delete orderitem_path(orderitem)
    #   must_respond_with :not_found
    # end
  end
end
