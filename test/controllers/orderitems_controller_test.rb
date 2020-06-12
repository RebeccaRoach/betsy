require "test_helper"

describe OrderitemsController do
  let(:existing_orderitem) { orderitems(:snow) }

  let(:update_hash){
    {
      orderitem: {
        quantity: 1,
      },
    }
  }

  describe "create function" do
    it "can create a new Orderitem with valid data" do
      expect {
        post product_orderitems_path(product_id: products(:rx_bar).id), params: update_hash
      }.must_change "Orderitem.count", 1

      expect(session[:order_id]).wont_be_nil

      new_orderitem = Orderitem.last

      expect(new_orderitem.product.product_name).must_equal "RxBar"
      expect(new_orderitem.order.orderitems.count).must_equal 1
      must_respond_with :redirect
    end
  end
end
