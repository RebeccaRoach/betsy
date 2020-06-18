require "test_helper"

describe Product do
  let (:new_product) {
    Product.new(
      product_name: "Mt. Everest",
      description: "Yeah that mountain",
      price: 300000,
      photo_url: "www.learningtoliketests.com/sort-of.png",
      stock: 3,
      retired: false,
      merchant_id: merchants(:diana).id
    )
  }

  # relationships
  describe "relationships" do
    it "belongs to merchant" do
      new_product.save
      new_product = Product.last
      puts new_product.inspect

      expect(new_product.merchant.valid?).must_equal true
      expect(new_product.merchant).must_be_instance_of Merchant
    end

    it "has and belongs to many categories" do
      
    end

    it "has many reviews" do
      
    end

    it "has many orderitems" do
      
    end

    it "has many orders through orderitems" do
      
    end
  end

  # validations
  describe "validations" do
    it "is valid when all fields are present" do
      expect(new_product.valid?).must_equal true
    end

    it "is invalid without a product name" do
    end

    it "is invalid without a price and must be greater than 0" do
    end

    it "is invalid without a stock and must be greater than 0" do
    end
  end



  # custom methods
  describe "custom methods" do
    describe "retire!" do
      it "can change a product's retired status from false to true" do
        
      end
    end
  end
end
