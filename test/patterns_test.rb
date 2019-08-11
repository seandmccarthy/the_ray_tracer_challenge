require 'minitest/autorun'
require_relative '../lib/pattern'
require_relative '../lib/stripe_pattern'
require_relative '../lib/gradient_pattern'
require_relative '../lib/ring_pattern'
require_relative '../lib/checker_pattern'
require_relative '../lib/tuple'
require_relative '../lib/matrix'
require_relative '../lib/transformation'

class TestPatterns < Minitest::Test
  class TestPattern < Pattern
    def pattern_at(point)
      Colour(point.x, point.y, point.z)
    end
  end

  def test_default_pattern_transformation
    pattern = TestPattern.new
    assert_equal pattern.transform, Matrix.identity(4)
  end

  def test_assigning_a_transformation
    pattern = TestPattern.new
    pattern.transform = translation(1, 2, 3)
    assert_equal pattern.transform, translation(1, 2, 3)
  end

  def test_creating_a_stripe_pattern
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.a, Colour::WHITE
    assert_equal pattern.b, Colour::BLACK
  end

  def test_a_stripe_pattern_is_constant_in_y
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 1, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 2, 0)), Colour::WHITE
  end

  def test_a_stripe_pattern_is_constant_in_z
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 0, 1)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 0, 2)), Colour::WHITE
  end

  def test_a_stripe_pattern_alternates_in_x
    pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0.9, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(1, 0, 0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(-0.1, 0, 0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(-1, 0, 0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(-1.1, 0, 0)), Colour::WHITE
  end

  def test_pattern_with_an_object_transformation
    o = Sphere()
    o.transform = scaling(2, 2, 2)
    pattern = TestPattern.new
    c = pattern.pattern_at_shape(shape: o, point: Point(2, 3, 4))
    assert_equal c, Colour(1, 1.5, 2)
  end

  def test_pattern_with_a_pattern_transformation
    o = Sphere()
    pattern = TestPattern.new
    pattern.transform = scaling(2, 2, 2)
    c = pattern.pattern_at_shape(shape: o, point: Point(2, 3, 4))
    assert_equal c, Colour(1, 1.5, 2)
  end

  def test_pattern_with_both_an_object_and_pattern_transformation
    o = Sphere()
    o.transform = scaling(2, 2, 2)
    pattern = TestPattern.new
    pattern.transform = translation(0.5, 1, 1.5)
    c = pattern.pattern_at_shape(shape: o, point: Point(2.5, 3, 3.5))
    assert_equal c, Colour(0.75, 0.5, 0.25)
  end

  def test_gradient_linearly_interpolates_between_colours
    pattern = GradientPattern(a: Colour::BLACK, b: Colour::WHITE)
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(0.25, 0, 0)), Colour(0.25, 0.25, 0.25)
    assert_equal pattern.pattern_at(Point(0.5, 0, 0)), Colour(0.5, 0.5, 0.5)
    assert_equal pattern.pattern_at(Point(0.75, 0, 0)), Colour(0.75, 0.75, 0.75)
  end

  def test_ring_pattern
    pattern = RingPattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(1.0, 0, 0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(0, 0, 1.0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(0.708, 0, 0.708)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(1.415, 0, 1.415)), Colour::WHITE
  end

  def test_checker_pattern_repeats_in_x_y_z
    pattern = CheckerPattern(a: Colour::WHITE, b: Colour::BLACK)
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0.99, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(1.01, 0, 0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 0.99, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 1.01, 0)), Colour::BLACK
    assert_equal pattern.pattern_at(Point(0, 0, 0)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 0, 0.99)), Colour::WHITE
    assert_equal pattern.pattern_at(Point(0, 0, 1.01)), Colour::BLACK
  end
end
