require "test_helper"

describe OrderitemsController do
  let(:existing_orderitem) { orderitems(:rxbar) }

  let(:update_hash) {
    {
      orderitem: {
        quantity: 1
      }
    }
  }

  describe "create" do
    it "can create a new orderitem with valid data" do
      before_count = Orderitem.count
      post product_orderitems_path(product_id: products(:snow_pass).id), params: update_hash
    
      expect(Orderitem.count).must_equal before_count + 1
      expect(session[:order_id]).wont_be_nil

      last_orderitem = Orderitem.last

      expect(last_orderitem.product).must_equal products(:snow_pass)
      expect(last_orderitem.order.orderitems.count).must_equal 1
      must_respond_with :redirect
      must_redirect_to cart_path(last_orderitem.order)
    end

    it "can increment the quantity of existing orderitem" do
      product_to_buy = products(:snow_pass)

      params = {
        orderitem: {
          quantity: 1,
          shipped: false
        }
      }

      before_count_orderitem = Orderitem.count
      before_count_order = Order.count

      post product_orderitems_path(product_id: products(:snow_pass).id), params: params
      expect(Order.count).must_equal before_count_order + 1

      post product_orderitems_path(product_id: products(:snow_pass).id), params: params
      expect(Order.count).must_equal before_count_order + 1
  
      expect(Orderitem.count).must_equal before_count_orderitem + 1
      expect(Orderitem.last.quantity).must_equal 2
    end

    it "does something if the product is out of stock????" do
      # create product with 0 stock
      # expect create post will return 400
      # should not create orderitem (check same count)
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant orderitem ID" do
      expect {
        patch orderitem_path(existing_orderitem), params: update_hash
      }.wont_change "Orderitem.count"
      
      updated_item = Orderitem.find_by(id: existing_orderitem.id)

      expect(updated_item.quantity).must_equal 1
      must_respond_with :redirect
      must_redirect_to cart_path(order_id: session[:order_id])
    end

    it "redirects to cart path without updating given bad data" do
      bogus_update_hash = {
        orderitem: {
          quantity: -1
        }
      }

      expect {
        patch orderitem_path(existing_orderitem), params: bogus_update_hash
      }.wont_change "Orderitem.count"

      must_respond_with :redirect
      must_redirect_to cart_path(order_id: session[:order_id])
    end

    it "redirects to cart path without updating given valid data but not pending status" do
      # DO WE NEED TO CHECK OTHER STATUSES AS WELL????
      update_hash = {
        orderitem: {
          quantity: 1
        }
      }

      existing_orderitem.order.update!(status: "complete")
      before_quantity = existing_orderitem.quantity

      expect {
        patch orderitem_path(existing_orderitem), params: update_hash
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

      delete orderitem_path(existing_orderitem)

      expect(Orderitem.count).must_equal before_count - 1
      must_redirect_to cart_path(order_id: session[:order_id])
    end

    it "fails to delete existing orderitem without an order status of pending, and redirects" do
      # DO WE NEED TO CHECK OTHER STATUSES AS WELL????
      before_count = Orderitem.count
      existing_orderitem.order.status = "complete"
      existing_orderitem.order.save!

      delete orderitem_path(existing_orderitem)

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
