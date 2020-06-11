class AddColumnsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :total, :float
    add_column :orders, :status, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :cc_name, :string
    add_column :orders, :cc_num, :bigint
    add_column :orders, :cvv, :integer
    add_column :orders, :cc_exp, :integer
    add_column :orders, :zip, :integer
  end
end
