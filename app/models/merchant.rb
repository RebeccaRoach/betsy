class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true, presence: true

  # custom mthod to create new merchant
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    return merchant
  end
  
  def total_revenue
    total_rev = 0
    self.products.each do |product|
      product.orderitems.each do |item|
        total += item.subtotal
      end
    end
    return total_rev
  end

  # double check on edge cases i.e. nil or pending order
  def total_revenue_by_status(status)
    total_rev_status = 0
    self.products.each do |product|
      product.orderitems.each do |item|
        if item.order.status == status
          total += item.subtotal
        end
      end
    end
    return total_rev_status
  end

end
