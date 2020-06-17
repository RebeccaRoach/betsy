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
  it "returns not found for the show action with an invalid id" do
    get order_path(id: -1)
    must_respond_with :not_found
  end

  decribe "update" do 
    it "can update an order with valid order information"
    end
  end
end
