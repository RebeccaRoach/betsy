class CreateOrderitems < ActiveRecord::Migration[6.0]
  def change
    create_table :orderitems do |t|
      t.integer :quantity # or available_quantity

      t.timestamps
    end
  end
end
