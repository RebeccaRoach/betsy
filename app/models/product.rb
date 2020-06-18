class Product < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :reviews

  has_many :orderitems
  has_many :orders, through: :orderitems

  def retire!
    self.update_attribute(:retired, true)
  end
end
