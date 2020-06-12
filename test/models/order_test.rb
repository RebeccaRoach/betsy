require "test_helper"

describe Order do
  let(:paid_order) { orders(:order2) }
  let(:pending_order) { orders(:pending_order) }

  describe "validation" do
    it "will not allow Orders to have no status" do
      paid_order.status = nil

      expect(paid_order.valid?).must_equal false
      expect(paid_order.errors.messages).must_include :status
      expect(paid_order.errors.messages[:status]).must_include "can't be blank"
    end
  end

  it "cannot have a status other than pending, paid or complete" do
    paid_order.status = "pending"
    expect(paid_order.valid?).must_equal true

    paid_order.status = "paid"
    expect(paid_order.valid?).must_equal true

    paid_order.status = "complete"
    expect(paid_order.valid?).must_equal true

    paid_order.status = "gretchen"
    expect(paid_order.valid?).must_equal false
    expect(paid_order.errors.messages).must_include :status
    expect(paid_order.errors.messages[:status]).must_include "gretchen is not a valid status"
  end

  it "can update an Order" do
    expect{ Orderitem.create(quantity: 1, order: pending_order, product: products(:rainer), shipped: false) }.must_change "pending_order.orderitems.count", 1

    expect{ 
      pending_order.update(
        email: "lady@gmail.com",
        address: "2020 my house street",
        cc_name: "Butterfly Cherry",
        cc_num: 41658214563,
        cvv: 589,
        cc_exp: "02/2023",
        zip: 98028,
        status: "paid"
      )
    }.wont_change "Order.count"

    expect(pending_order.email).must_equal "lady@gmail.com"
    expect(pending_order.address).must_equal "2020 my house street"
    expect(pending_order.cc_name).must_equal "Butterfly Cherry"
    expect(pending_order.cc_num).must_equal 41658214563
    expect(pending_order.cvv).must_equal 589
    expect(pending_order.cc_exp).must_equal "02/2023"
    expect(pending_order.zip).must_equal 98028
    expect(pending_order.status).must_equal "paid"
    expect(pending_order.orderitems.length).must_equal 1
  end

  it "cannot update an Order" do
    expect(pending_order.orderitems.count).must_equal 0

    expect( 
      pending_order.update(
        email: "lady@gmail.com",
        address: "2020 my house street",
        cc_name: "Butterfly Cherry",
        cc_num: 41658214563,
        cvv: 589,
        cc_exp: "02/2023",
        zip: 98028,
        status: "paid"
      )
    ).must_equal false

    updated_order = Order.find_by(id: pending_order.id)

    expect(updated_order.email).must_be_nil
    expect(updated_order.address).must_be_nil
    expect(updated_order.cc_name).must_be_nil
    expect(updated_order.cc_num).must_be_nil
    expect(updated_order.cvv).must_be_nil
    expect(updated_order.cc_exp).must_be_nil
    expect(updated_order.zip).must_be_nil
    expect(updated_order.status).must_equal "pending"
    
  end
end
