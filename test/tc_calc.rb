require "test/unit"
require "../sample/calc"

include Calc
class TestCalc < Test::Unit::TestCase
  def test_plus
    assert_equal(2+3, Plus.new(2,3).x)
  end

  def test_minus
    assert_equal(20-12, Minus.new(20, 12).x)
  end

  def test_multiple
    assert_equal(4*8, Multiple.new(4, 8).x)
  end

  def test_devide
    assert_equal(32/4, Divide.new(32, 4).x)
  end

  def test_functions
    assert_equal(2+3, plus(2,3).x)
    assert_equal(20-12, minus(20, 12).x)
    assert_equal(4*8, multiple(4, 8).x)
    assert_equal(32/4, divide(32, 4).x)
  end

  def test_mix
    exp = divide( plus(2, multiple(3,4)), 3 )
    assert_equal((2+3*4)/3, exp.x)
  end
end