class Product < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :reviews

  has_many :orderitems
  # product.orders => all the orders that a product has been attached to
  has_many :orders, through: :orderitems
end
