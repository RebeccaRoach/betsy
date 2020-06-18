require "test_helper"
require "pry"

describe Merchant do
  describe "total_revenue" do
    it "correctly calculates the total revenue for a merchant" do
      merchant = merchants(:greta)
      # 2.45 for rxbar in order3 + 5,000 for rainier in order4 + 5,000 for rainier in order5
      # formatting for money correct???
      expect(merchant.total_revenue).must_equal 10002.45
    end

    it "returns 0 if a merchant has not sold any products" do
      merchant = merchants(:no_products_merchant)
   
      expect(merchant.total_revenue).must_equal 0
    end
  end

  describe "all_orders" do
    it "finds all the orders containing at least one item from a merchant" do
      merchant = merchants(:greta)
      merchant2 = merchants(:bob)

      # from fixtures, greta's products (snow_pass) are in 3 separate orders
      # while bob's products are in 4 orders
      expect(merchant.all_orders).must_be_kind_of Array
      expect(merchant.all_orders.length).must_equal 3
      expect(merchant2.all_orders.length).must_equal 4
    end

    it "returns an empty array if there are no items from that merchant in any order" do
      merchant = merchants(:no_products_merchant)
   
      expect(merchant.all_orders.count).must_equal 0
  let(:merchant) {
    Merchant.new(
      username: "Hollerin Harriet",
      email: "Holler@harriet.com",
      uid: 1115,
      provider: "github"
    )
  }
  describe "validations" do
    it "is valid with all fields present and valid" do
      expect(merchant.valid?).must_equal true
    end

    it "is invalid without a username" do
      merchant.username = nil

      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end

    it 'is invalid without a unique email address' do
      invalid_merchant = Merchant.create(username: "new merchant", email: " ")

      expect(invalid_merchant.valid?).must_equal false
      expect(invalid_merchant.errors.messages).must_include :email
    end

    describe "relations" do
      it "can have one or many products" do
        merchant.must_respond_to :products
        merchant.products.each do |product|
        product.must_be_kind_of Product
        end
      end


      it "can have one or more order items through products" do
        merchant.must_respond_to :order_items
        merchant.order_items.each do |order_item|
          order_item.must_be_kind_of OrderItem
        end
      end

    end
  end

  describe "build_from_github" do 
    it "creates a new merchant" do 
      auth_hash = {
        provider: "github",
        uid: 1115 ,
        "info" => {
          "email" => "merchant@email.com",
          "username" => "Hollerin Harriet"
        }
      }

      merchant = Merchant.build_from_github(auth_hash)
      merchant.save!

      expect(Merchant.count).must_equal 1

      expect(merchant.provider).must_equal auth_hash[:provider]
      expect(merchant.uid).must_equal auth_hash[:uid]
      expect(merchant.username).must_equal auth_hash["info"]["username"]
      expect(merchant.email).must_equal auth_hash["info"]["email"]
    end
  end

  describe "custom methods made" do
    describe "total_revenue" do
      it "calculates the total revenue" do
        # need to validate how much they have in their total revenue
        expect(merchant.total_revenue).must_equal 11.11
      end

      it "returns 0 if the merchant has no revenue" do
        expect(merchant.total_revenue).must_equal 0
      end
    end

    describe "revenue_by_status" do
      it "calculates the total revenue by status passed in" do
        # veriyf the must_equal to the two following
        expect(merchant.total_revenue_by_status("paid")).must_equal 11.15
        expect(merchant.total_revenue_by_status("pending")).must_equal 831.06
      end

      # it "will return 0 for a non-existing status" do
      #   # verify the n/a message
      #   expect(merchant(:canoeing_chris).total_revenue_by_status("n/a")).must_equal 0.0
      # end
      expect(merchant.all_orders).must_be_kind_of Array
      expect(merchant.all_orders).must_be_empty
    end
  end
  
  describe "order_status" do
    it "finds all of a merchant's orders of a certain status" do
      merchant = merchants(:greta)

      expect(merchant.order_status("complete")).must_be_kind_of Array
      expect(merchant.order_status("complete").length).must_equal 2
      expect(merchant.order_status("cancelled").length).must_equal 1
    end

    it "returns an empty collection if there are no merchant orders of a certain status" do
      merchant = merchants(:greta)
      # greta does not have any pending orders...
      expect(merchant.order_status("pending")).must_be_kind_of Array
      expect(merchant.order_status("pending").length).must_equal 0
    end
  end

  describe "revenue_by_status" do
    it "returns the correct total revenue for a merchant's products sold in an order of a given status" do
      merchant = merchants(:greta)

      expect(merchant.revenue_by_status("complete")).must_equal 5002.45

  # NOT SURE IF THIS IS CORRECT FOR CANCELLED ORDER REVENUE???? (DELETE IF UNSURE)
      expect(merchant.revenue_by_status("cancelled")).must_equal 5000
    end

    it "returns 0 if there is no revenue associated with merchant orders of a certain status" do
      merchant = merchants(:greta)
      # greta does not have any pending orders... (?)
      expect(merchant.order_status("pending")).must_equal 0
    end
  end
end
