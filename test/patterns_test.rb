require 'minitest/autorun'
require_relative '../lib/stripe_pattern'
require_relative '../lib/tuple'
require_relative '../lib/transformation'

class TestPatterns < Minitest::Test
  def test_creating_a_stripe_pattern
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.a, Colour::WHITE
    assert_equal pattern.b, Colour::BLACK
  end

  def test_a_stripe_pattern_is_constant_in_y
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.stripe_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.stripe_at(Point(0, 1, 0)), Colour::WHITE
    assert_equal pattern.stripe_at(Point(0, 2, 0)), Colour::WHITE
  end

  def test_a_stripe_pattern_is_constant_in_z
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.stripe_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.stripe_at(Point(0, 0, 1)), Colour::WHITE
    assert_equal pattern.stripe_at(Point(0, 0, 2)), Colour::WHITE
  end

  def test_a_stripe_pattern_alternates_in_x
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.stripe_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.stripe_at(Point(0.9, 0, 0)), Colour::WHITE
    assert_equal pattern.stripe_at(Point(1, 0, 0)), Colour::BLACK
    assert_equal pattern.stripe_at(Point(-0.1, 0, 0)), Colour::BLACK
    assert_equal pattern.stripe_at(Point(-1, 0, 0)), Colour::BLACK
    assert_equal pattern.stripe_at(Point(-1.1, 0, 0)), Colour::WHITE
  end

  def test_stripes_with_an_object_transformation
    o = Sphere()
    o.transform = scaling(2, 2, 2)
    pattern = StripePattern(a: Colour::BLACK, b: Colour::WHITE)
    c = pattern.stripe_at_object(o, Point(1.5, 0, 0))
    assert_equal c, Colour::BLACK
  end

  def test_stripes_with_a_pattern_transformation
    o = Sphere()
    pattern = StripePattern(a: Colour::BLACK, b: Colour::WHITE)
    pattern.transform = scaling(2, 2, 2)
    c = pattern.stripe_at_object(o, Point(1.5, 0, 0))
    assert_equal c, Colour::BLACK
  end

  def test_stripes_with_both_an_object_and_pattern_transformation
    o = Sphere()
    o.transform = scaling(2, 2, 2)
    pattern = StripePattern(a: Colour::BLACK, b: Colour::WHITE)
    pattern.transform = translation(0.5, 0, 0)
    c1 = pattern.stripe_at_object(o, Point(2.5, 0, 0))
    c2 = pattern.stripe_at_object(o, Point(0.4, 0, 0))
    assert_equal c1, Colour::BLACK
    assert_equal c2, Colour::WHITE
  end
end
