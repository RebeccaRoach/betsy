class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true, presence: true

  # custom mthod to create new merchant
  def self.build_from_github(auth_hash)
    merchant = Merchant.news
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash[:info][:username]
    merchant.email = auth_hash[:info][:email]
    return merchant
  end

  def total_revenue
    revenue = 0
    orders = self.all_orders
    
    orders.each do |order|
      order.orderitems.each do |item|
        if item.product.merchant_id == self.id
          product = Product.find_by(id: item.product_id)
          price = product.price
          revenue += price
        end
      end
    end

    return revenue
  end

  def all_orders
    merchant_orders = []
    
    Order.all.each do |order|
      order.orderitems.each do |item|
        if item.product.merchant_id == self.id
          order = Order.find_by(id: item.order_id)
          merchant_orders << order
          break
        end
      end
    end

    return merchant_orders
  end

  def order_status(status)
    # return all of the merchant's orders with a certain status
    orders = self.all_orders
    status_orders = []
    
    orders.each do |order|
      if order.status == status
        status_orders << order
      end
    end

    return status_orders
  end


  def revenue_by_status(status)
    revenue_by_status = 0
    orders_of_a_status = self.order_status(status)

    orders_of_a_status.each do |order|
      order.orderitems.each do |item|
        if item.product.merchant_id == self.id
          product = Product.find_by(id: item.product_id)
          price = product.price
          revenue_by_status += price
        end
      end
    end

    return revenue_by_status
  end
end