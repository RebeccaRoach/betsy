class AddColumnsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :total, :float
    change_column :orders, :status, :string
    change_column :orders, :email, :string
    change_column :orders, :address, :string
    change_column :orders, :cc_name, :string
    change_column :orders, :cc_num, :bigint
    change_column :orders, :cvv, :integer
    change_column :orders, :cc_exp, :integer
    change_column :orders, :zip, :integer
  end
end
