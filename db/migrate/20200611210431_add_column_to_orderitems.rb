class AddColumnToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :orderitems, :quantity, :bigint
  end
end
