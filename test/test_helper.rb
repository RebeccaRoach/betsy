require "pry"
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of order output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # helper method to set session for a valid order
  def make_order
    # new_order = Order.create!(
    #   status: "pending",
    #   total: 5,
    #   email: "greenleaf@gmail.com",
    #   address: "1516 Mesa Verde",
    #   cc_name: "Mastercard",
    #   cc_num: 8788082,
    #   cvv: 572,
    #   cc_exp: "06/20",
    #   zip: 74804
    # )

    # orderitem = Orderitem.create!(
    #   quantity: 1,
    #   order: new_order,
    #   product: products(:rainier),
    #   shipped: false
    # )

    # new_order.orderitems << orderitem

    # if new_order.save!
    #   session[:order_id] = new_order.id
    #   puts "SESSION ID: #{session[:order_id]}"
    #   puts "COUNT: #{new_order.orderitems.count}"
    # else
    #   puts "ORDER FAILED TO SAVE"
    # end

    # return new_order

    orderitem = Orderitem.create!(quantity: 1, order: orders(:order2), product: products(:rainier), shipped: false)
    @order = Order.find_by(id: orderitem.order_id)
    # expect id = 2
    puts "HERE IS ORDER ID: #{@order.id}"
    return @order
  end
end
