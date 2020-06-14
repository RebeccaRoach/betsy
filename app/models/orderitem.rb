class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :shipped, inclusion: { in: [true, false], message: "shipped status : true or false"}
  # validates :in_stock
  # validates :not_retired

  def subtotal
    subtotal = (self.quantity) * (self.product.price)
    return subtotal.round(2)
  end

  private

  def in_stock
    if quantity && product && quantity > product.stock
      errors.add(:quantity, "order exceeds in-stock inventory")
    end
  end

  def not_retired
    if product && product.retired
      errors.add(:product_id, "#{product.name} is no longer available")
    end
  end
end
