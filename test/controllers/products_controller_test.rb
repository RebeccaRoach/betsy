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
    let (:product_hash) {
      {
        product: {
          product_name: "Mt. Everest",
          description: "Yeah that mountain",
          price: 300000,
          photo_url: "www.learningtoliketests.com/sort-of.png",
          stock: 3,
          retired: false,
          merchant_id: merchants(:diana).id
        }
      }
    }

    it "can create a new product, and responds with a redirect" do
      expect {
        post products_path, params: product_hash
      }.must_differ 'Product.count', 1

      must_redirect_to product_path(Product.last)
      expect(Product.last.product_name).must_equal product_hash[:product][:product_name]
    end

    it "does not create a product if given bad data, and responds with a redirect" do
      
    end

  end


  # describe "create" do
  #   let (:passenger_hash) {
  #     {
  #       passenger: {
  #         name: "Cookie Monster", 
  #         phone_num: "9999"
  #       }
  #     }
  #   }

    # it "can create a new passenger with valid information accurately, and redirect" do
    #   expect {
    #     post passengers_path, params: passenger_hash
    #   }.must_differ 'Passenger.count', 1

    #   must_redirect_to root_path
    #   expect(Passenger.last.name).must_equal passenger_hash[:passenger][:name]
    #   expect(Passenger.last.phone_num).must_equal passenger_hash[:passenger][:phone_num]
    # end

    # it "does not create a passenger if the form if the form has invalid name, and responds with a redirect" do
    #   no_name = passenger_hash[:passenger][:name] = nil

    #   expect {
    #     post passengers_path, params: no_name
    #   }.must_differ 'Passenger.count', 0

    #   must_respond_with  :redirect
    #   must_redirect_to new_passenger_path
    # end
  # end

  describe "update" do
    
  end

  describe "edit" do
    
  end

  describe "retired" do
    
  end
end
