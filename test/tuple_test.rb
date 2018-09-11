require 'minitest/autorun'
require_relative '../lib/tuple'

class TestTuple < Minitest::Test
  def test_tuple_with_non_zero_w_is_a_point
    tuple = Tuple.new(4.3, -4.2, 3.1, 1.0)
    assert_equal tuple, Point.new(4.3, -4.2, 3.1)
  end

  def test_tuple_with_zero_w_is_a_vector
    tuple = Tuple.new(4.3, -4.2, 3.1, 0)
    assert_equal tuple, Vector.new(4.3, -4.2, 3.1)
  end

  def test_add_tuples
    tuple1 = Tuple.new(3, -2, 5, 1)
    tuple2 = Tuple.new(-2, 3, 1, 0)
    assert_equal tuple1 + tuple2, Tuple.new(1, 1, 6, 1)
  end

  def test_subtracting_points_gives_a_vector
    p1 = Point.new(3, 2, 1)
    p2 = Point.new(5, 6, 7)
    assert_equal p1 - p2, Vector.new(-2, -4, -6)
  end
end
