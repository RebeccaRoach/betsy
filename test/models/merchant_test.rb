require "test_helper"

describe Merchant do
  let (:merchant) {merchant(:canoeing_chris)}

  describe "validations" do

    it "is valid with all fields present and valid" do
      expect(merchant.valid?).must_equal true
    end

    it 'is invalid without an email address' do
      merchant.email = nil

      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :email
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

  describe "custom methods made" do
    describe "total_revenue" do
      it "calculates the total revenue" do
        # need to validate how much they have in their total revenue
        expect(merchant(:canoeing_chris).total_revenue).must_equal 11.11
      end

      it "returns 0 if the merchant has made no sales" do
        expect(merchant(:canoeing_chris).total_revenue).must_equal 0
      end
    end

    describe "revenue_by_status" do
      it "calculates the total revenue by status passed in" do
        # verif the must_equal to the two following
        expect(merchant(:trailin_trinity).total_revenue_by_status("paid")).must_equal 11.15
        expect(merchant(:fishin_fiona).total_revenue_by_status("pending")).must_equal 831.06
      end

      it "will return 0 for a non-existing status" do
        # verify the n/a message
        expect(merchant(:canoeing_chris).total_revenue_by_status("n/a")).must_equal 0.0
      end
    end
  end
end
