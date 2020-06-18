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
