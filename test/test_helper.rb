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
    # empty_order = Order.new(status: "pending")
    # orderitem = orderitems(:rainer)
    # # orderitem.order_id = empty_order.id
    # orderitem.save!
    # @order = Order.find_by(id: orderitem.order.id)
    # return @order

    orderitem = Orderitem.create!(quantity: 1, order: orders(:order2), product: products(:rainer), shipped: false)
    @order = Order.find_by(id: orderitem.order.id)
    # expect id = 2
    puts "ORDER ID: #{@order.id}"
    return @order
  end
end
