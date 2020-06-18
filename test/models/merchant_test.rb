require "test_helper"
require "pry"

describe Merchant do
  describe "all_orders" do
    it "finds all the orders containing at least one item from a merchant" do
      merchant = merchants(:greta)
      merchant2 = merchants(:bob)

      # from fixtures, greta's products (snow_pass) are in 2 separate orders
      # while bob's products are in 4 orders
      expect(merchant.all_orders.count).must_equal 2
      expect(merchant2.all_orders.count).must_equal 4
    end

    it "returns no orders if there are no items from that merchant in any order" do
      merchant = merchants(:no_products_merchant)
   
      expect(merchant.all_orders.count).must_equal 0
    end
  end
end
