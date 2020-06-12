require "test_helper"
require "pry"

describe OrdersController do
  let(:valid_params){
    {
      order:{
        email: "test@gmail.com",
        address: "123  test avenue",
        cc_name: "Jane Doe",
        cc_num: 12345,
        cvv: 123,
        cc_exp: "06/2020",
        zip: 987654,
      },
    }
  }
  describe "cart" do
    it "redirects to root path and provides a message if cart is empty" do
      get cart_path
      must_respond_with :redirect
      must_redirect_to root_path
      expect(flash[:status]).must_equal :failure
    end
    it "finds the correct order id for a valid cart" do
      # has at least one orderitem

    end
  end
  describe "show" do
    it "returns not found for the show action with an invalid ID" do
      get order_path(id: -1)
      must_respond_with :not_found
    end
    it "returns valid ID"
  end
  describe "initialized cart/orders" do
    before do
      post product_orderitems_path(product_id: products(:nature).id), params: { orderitem: { quantity: 2, }, }
      post product_orderitems_path(product_id: products(:cliff).id), params: { orderitem: { quantity: 1, }, }
      post product_orderitems_path(product_id: products(:chewy).id), params: { orderitem: { quantity: 3, }, }
    end
  end
end
