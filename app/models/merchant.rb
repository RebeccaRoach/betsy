class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true, presence: true

  # custom mthod to create new merchant
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash[:info][:username]
    merchant.email = auth_hash[:info][:email]
    return merchant
  end

  # need to work with OrderItem
  def self.total_revenue

  end

  def all_orders
    merchant_orders = []
    
    Order.all.each do |order|
      order.orderitems.each do |item|
        if item.product.merchant_id == self.id
          merchant_orders << item.order_id
          break
        end
      end
    end

    return merchant_orders
  end

  # need to work with OrderItem
  def revenue_by_status(status)
  
  end

end
