class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0}
  # do we need below?
  validates :shipped, inclusion: { in: [true, false], message: "shipped status : must be true or false"}
  # validates :enough_stock, exclusion false?******
  # validates :not_retired

  def subtotal
    subtotal = (self.quantity) * (self.product.price)
    return subtotal.round(2)
  end

  private

  # mark_shipped for order (Order in charge of gateway: check this item shipped, check if can mark complete on whole order)
  # check if the order is complete?
  # if so, 
  # order.mark_item_shipped(id)
  # can mark whole order complete

  # def marked_item_shipped
  #   single orderitem change shipped status
  # end

  def enough_stock
    # correct syntax??
    if !self.product.enough_stock?(quantity)
      errors.add(:quantity, "order exceeds in-stock inventory")
    end
  end

  def not_retired
    if product && product.retired
      errors.add(:product_id, "#{product.name} is no longer available")
    end
  end
end
