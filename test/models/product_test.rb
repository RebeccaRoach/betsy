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
      expect { 
        products(:snow_pass).categories << [categories(:parking_pass), categories(:gear)] 
        }.must_differ "products(:snow_pass).categories.count", 2

      products(:snow_pass).categories.each do |category|
        expect(category).must_be_instance_of Category
      end
    end

    it "has many reviews" do
      review1 = Review.create(content: "Wow testing is so fun", rating: 5, product_id: products(:snow_pass))
      review2 = Review.create(content: "Testing is necessary but sometimes I'm just not feeling it", rating: 3, product_id: products(:snow_pass))

      expect {
        products(:snow_pass).reviews << [review1, review2]
      }.must_differ "products(:snow_pass).reviews.count", 2

      products(:snow_pass).reviews.each do |review|
        expect(review).must_be_instance_of Review
      end
    end

    it "has many orderitems" do
      expect(products(:rx_bar).orderitems.count).must_equal 2

      products(:rx_bar).orderitems.each do |orderitem|
        expect(orderitem).must_be_instance_of Orderitem
      end
    end

    it "has many orders through orderitems" do
      products(:rx_bar).orderitems.each do |orderitem|
        expect(orderitem).must_be_instance_of Orderitem
        expect(orderitem.order).must_be_instance_of Order
      end
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

    describe "average_rating" do
      
    end
  end
end
