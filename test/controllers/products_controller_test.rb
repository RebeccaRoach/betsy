require "test_helper"

describe ProductsController do
  before do
    @invalid_product_id = -1
  end

  describe "index" do
    it "responds with success when there are many products saved" do
      Product.create(product_name: 'Smartwool Socks', price: 20.00)
      Product.create(product_name: 'Cliff Coffee Bar', price: 2.00)

      get products_path

      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      get products_path

      must_respond_with :success
    end
  end


  describe "show" do
    it "responds with success when showing an existing valid product" do
      # TODO
      products(:snow_pass).merchant = merchants(:diana)
      products(:snow_pass).save

      valid_product_id = products(:snow_pass).id


      get product_path(valid_product_id)

      must_respond_with :success
    end

    it "responds with 404 with an invalid product id" do
      get product_path(@invalid_product_id)

      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      get new_product_path

      must_redirect_to root_path
    end
  end

  describe "create" do
    
  end

  describe "update" do
    
  end

  describe "edit" do
    
  end

  describe "retired" do
    
  end
end
