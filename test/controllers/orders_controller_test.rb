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
end
