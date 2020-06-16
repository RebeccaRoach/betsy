class RemoveCategoriesProductsJoin < ActiveRecord::Migration[6.0]
  def change
    drop_table :categories_products_join
  end
end
