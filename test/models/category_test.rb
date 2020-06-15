require "test_helper"

describe Category do
  describe "relations" do
    it "can belong to a product" do
      product = products(:nature_valley)
      category = Category.create!(category_name: "test category")
      product_initial_category_count = product.categories.count
      # nature_valley has no categories to start with
      expect(product.categories.count).must_equal 0

      product.categories << category

      expect(product.categories.count).must_equal product_initial_category_count + 1
      expect(product.categories[0].category_name).must_equal category.category_name
    end

    it "can have multiple categories on one product" do
      product1 = products(:nature_valley)
      category1 = Category.create!(category_name: "test category")
      category2 = Category.create!(category_name: "cooler test category")
      product_initial_category_count = product1.categories.count
      # no categories to start with
      expect(product1.categories.count).must_equal 0

      product1.categories << category1

      expect(product1.categories.count).must_equal product_initial_category_count + 1
      expect(product1.categories[0].category_name).must_equal category1.category_name

      product1.categories << category2

      expect(product1.categories.count).must_equal product_initial_category_count + 2
      expect(product1.categories[1].category_name).must_equal category2.category_name
    end

    it "can be applied to zero, one, or multiple products" do
      test_category1 = categories(:category1)
      test_category2 = categories(:category2)
      no_products_category = categories(:no_products_category)

      expect(test_category1.products.count).must_equal 2
      expect(test_category2.products.count).must_equal 1
      expect(no_products_category.products.count).must_equal 0

      # test_merchant = Merchant.create!(username: "Shrek", email: "shrek@fiona.com")

      # test_category = Category.create!(category_name: "very cool category name")
      # puts "TEST CATEGORY ID:::::: #{test_category.id}"
      # expect(test_category.products.count).must_equal 0

      # product1 = products(:snow_pass)
      # product1.merchant_id = test_merchant.id
      # product1.save!
      # expect(product1.categories.count).must_equal 0

      # product2 = products(:rainier)
      # product2.merchant_id = test_merchant.id
      # product2.save!

      # # apply test_category to one product
      # product1.categories << test_category
      # product1.save!
      # expect(product1.categories.count).must_equal 1
      # expect(product1.categories[0].category_name).must_equal test_category.category_name

      # # apply test_category to another product
      # product2.categories << test_category
      # product2.save!
      # expect(product2.categories.count).must_equal 1
      # expect(product2.categories[0].category_name).must_equal test_category.category_name

      # # check how many products share the same category_id*************
      # result = Product.find(:all, :include => :categories, :conditions => { "categories_products.category_id" => test_category.id })
      # puts "HERE IS THE RESULT::::::: #{RESULT}"
      # User.find(:all, :include => :events, :conditions => { "events_users.event_id" => nil})
    end
  end

  # For sorting???
  describe "custom methods" do

  end


end
