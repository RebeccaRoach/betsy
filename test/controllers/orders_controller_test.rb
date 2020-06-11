require "test_helper"

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

  describe "empty cart" do
    it "redirects to root path and provides a message" do
      get cart_path
      must_respond_with :redirect
      must_redirect_to root_path
      expect(flash[:status]).must_equal :failure
    end
  end
end
