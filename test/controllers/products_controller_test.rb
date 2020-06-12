require "test_helper"

describe ProductsController do
  before do
    @invalid_product_id = -1
  end

  describe "index" do
    it "responds with success when there are many passengers saved" do
      Product.create(product_name: 'Smartwool Socks', price: 20.00)
      Product.create(product_name: 'Cliff Coffee Bar', price: 2.00)

      get "/products"

      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      get "/products"

      must_respond_with :success
    end
  end
end
