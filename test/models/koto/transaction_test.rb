require 'test_helper'

class Koto::TransactionTest < ActiveSupport::TestCase
  test 'send!' do
    assert_equal(0, Koto::Transaction.count)
    t = Koto::Transaction.new(address: 'address', ip_address: '127.0.0.1')
    t.send!
    assert_equal(1, Koto::Transaction.count)

    t = Koto::Transaction.new(address: 'address', ip_address: '127.0.0.2')
    assert_raises(RuntimeError) { t.send! }
    assert_equal(1, Koto::Transaction.count)

    t = Koto::Transaction.new(address: 'address2', ip_address: '127.0.0.2')
    t.send!
    assert_equal(2, Koto::Transaction.count)

    t = Koto::Transaction.new(address: 'address3', ip_address: '127.0.0.2')
    assert_raises(RuntimeError) { t.send! }
    assert_equal(2, Koto::Transaction.count)

    t = Koto::Transaction.new(address: 'address3', ip_address: '127.0.0.3')
    t.send!
    assert_equal(3, Koto::Transaction.count)

    # 他通貨
    assert_equal(0, Monacoin::Testnet::Transaction.count)
    t = Monacoin::Testnet::Transaction.new(address: 'address', ip_address: '127.0.0.1')
    t.send!
    assert_equal(1, Monacoin::Testnet::Transaction.count)

    assert_equal(0, Monacoin::Transaction.count)
    t = Monacoin::Transaction.new(address: 'address', ip_address: '127.0.0.1')
    t.send!
    assert_equal(1, Monacoin::Transaction.count)
  end

  test 'calc_value' do
    t = Koto::Transaction.new
    assert_equal 0.00022111, t.calc_value
  end
end