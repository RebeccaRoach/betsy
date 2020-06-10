class Product < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :reviews
end
