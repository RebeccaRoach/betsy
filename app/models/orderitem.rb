class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :shipped, inclusion: { in: [true, false],message: "shipped status : true or false"}

  # validate :in_stock
  # validate :not_retired

  # def subtotal
  #
  # end

  private
  # def in_stock
  # 
  # end

  # def not_retired
  #
  # end
end
