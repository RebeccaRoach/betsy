#todo
# create a shipped column (bool) maybe product needs that 'retired' column on it's side
# create a table with orders info and migrate

class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems

  validates :status, presence: true, inclusion: { 
    in: %w(pending paid complete cancelled),
    message: "%{value} is not a valid status" 
  }

  validates :orderitems, length: { minimum: 1, message: "Your cart is empty" }, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_num, presence: true, numericality: { only_integer: true }, length: { minimum: 4 }, on: :update
  validates :cvv, presence: true, numericality: { only_integer: true }, on: :update
  validates :cc_exp, presence: true, on: :update
  validates :zip, presence: true, numericality: { only_integer: true }, on: :update

  # custom methods
  def reduce_stock
    self.orderitems.each do |orderitem|
      orderitem.product.stock -= orderitem.quantity
      orderitem.product.save!
    end
  end

  def return_stock
    self.orderitems.each do |orderitem|
      if !orderitem.product.retired
        orderitem.product.stock += orderitem.quantity
        orderitem.product.save!
      end
    end
  end

  def total
    total_cost = 0

    self.orderitems.each do |orderitem|
      total_cost += orderitem.subtotal
    end

    return total_cost
  end

  def mark_as_complete!
    if self.status == "paid" && self.orderitems.find_by(shipped: false).nil?
      self.status = "complete"
      self.save!
    else
      raise Exception, "Order is not paid or all items haven't shipped"
    end
    # need else statement??
  end

  def change_to_paid!
    # change order status to paid
    self.status = "paid"
    self.save!
    # need else statement?
  end

  def clear_cart
    session[:order_id] = nil
  end

  # order instance method or class method?
  def checkout
    self.orderitems.each do |orderitem|
      if !orderitem.enough_stock?(orderitem.quantity)
        puts "THERE WASNT ENOUGH STOCK FOR #{orderitem.product.product_name}"
        return false
      end
    end

    self.reduce_stock
    result = self.change_to_paid!
    if !result
      puts "CHANGE TO PAID DID NOT WORK"
      return false
    end

    # clear cart
    self.clear_cart
  end

  def is_order_of(merch_id)
    if self.products.find_by(merchant_id: merch_id).nil?
      return false
    end
    
    return true
  end
end
