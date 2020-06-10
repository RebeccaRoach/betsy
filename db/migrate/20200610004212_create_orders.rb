class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      # check w/becca for naming variables
      # t.string :email
      # t.string :address
      # t.string :cc_name
      # t.string :cc_num
      # t.string :cvv
      # t.string :cc_exp
      # t.string :zip
      # t.string :status

      t.timestamps
    end
  end
end
