class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :shipped, inclusion: { in: [true, false],message: "shipped status : true or false"}

  validate :in_stock
  validate :not_retired

  def subtotal
    return (self.quantity) * (self.product.price)
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
