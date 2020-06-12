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

    it "returns not found when trying to edit" do
      get edit_order_path(id: Order.first.id)
      must_respond_with :not_found
    end

    it "returns not found when trying to update" do
      expect { patch order_path(id: Order.first.id), params: valid_params }.wont_change "Order.count"
      must_respond_with :not_found
    end

    # it "finds the correct order id for a valid cart" do
    #   # make an order
    #   valid_order = make_order
    #   # we can check the session[order_id] to be set
    #   puts "HERE IS VALID_ORDER: #{valid_order.status}"
    #   expect(session[:order_id]).wont_be_nil
    #   expect(@order).wont_be_nil
    #   expect(@order.id).must_equal session[:order_id]
    # end
  end
  describe "show" do
    it "returns not found for the show action with an invalid id" do
      get order_path(id: -1)
      must_respond_with :not_found
    end

    it "redirects for orders with a valid id" do
      get order_path(id: orders(:order1))
      must_redirect_to root_path
      expect(flash[:status]).must_equal :failure
    end

    #ActionController::MissingExactTemplate: OrdersController#show is missing a template for request formats: text/html
    # it "responds with success for valid orders with paid status" do
    #   get order_path(id: orders(:order2))
    #   must_respond_with :success
    # end

  end

  # describe "initialized cart" do
  #   before do
  #     # path that connects product and orderitems?
  #     post comment? (product_id: products(:nature_valley).id), params: { orderitem: { quantity: 2, }, }
  #   end
  #   describe "cart" do
  #     it "returns success for an existing session order id" do
  #       get cart_path
  #       must_respond_with :success
  #     end
  #   end
  # end
end
