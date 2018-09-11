require 'minitest/autorun'
require_relative '../lib/tuple'

class TestTuple < Minitest::Test
  def test_tuple_with_non_zero_w_is_a_point
    tuple = Tuple(4.3, -4.2, 3.1, 1.0)
    assert_equal tuple, Point(4.3, -4.2, 3.1)
  end

  def test_tuple_with_zero_w_is_a_vector
    tuple = Tuple(4.3, -4.2, 3.1, 0)
    assert_equal tuple, Vector(4.3, -4.2, 3.1)
  end

  def test_add_tuples
    tuple1 = Tuple(3, -2, 5, 1)
    tuple2 = Tuple(-2, 3, 1, 0)
    assert_equal tuple1 + tuple2, Tuple(1, 1, 6, 1)
  end

  def test_subtracting_points_gives_a_vector
    p1 = Point(3, 2, 1)
    p2 = Point(5, 6, 7)
    assert_equal p1 - p2, Vector(-2, -4, -6)
  end

  def test_substracting_a_vector_from_a_point
    p = Point(3, 2, 1)
    v = Vector(5, 6, 7)
    assert_equal p - v, Point(-2, -4, -6)
  end

  def test_subtracting_two_vectors
    v1 = Vector(3, 2, 1)
    v2 = Vector(5, 6, 7)
    assert_equal v1 - v2, Vector(-2, -4, -6)
  end

  def test_negating_a_vector
    t = Tuple(1, -2, 3, -4)
    assert_equal(-t, Tuple(-1, 2, -3, 4))
  end

  def test_multiplying_a_tuple_by_a_scalar
    t = Tuple(1, -2, 3, -4)
    assert_equal t * 3.5, Tuple(3.5, -7, 10.5, -14)
  end

  def test_dividing_a_tuple_by_a_scalar
    t = Tuple(1, -2, 3, -4)
    assert_equal t / 2, Tuple(0.5, -1, 1.5, -2)
  end

  def test_magnitude_of_a_vector
    v1 = Vector(1, 2, 3)
    v2 = Vector(-1, -2, -3)
    assert_equal v1.magnitude.round(Tuple::EPSILON),
                 Math.sqrt(14).round(Tuple::EPSILON)
    assert_equal v2.magnitude.round(Tuple::EPSILON),
                 Math.sqrt(14).round(Tuple::EPSILON)
  end

  def test_normalise_a_vector
    v = Vector(1, 2, 3)
    assert_equal v.normalise, Vector(0.26726, 0.53452, 0.80178)
  end

  def test_magnitude_of_normalised_vector
    v = Vector(1, 2, 3)
    assert_equal v.normalise.magnitude.round(Tuple::EPSILON), 1
  end

  def test_dot_product_of_two_vectors
    v1 = Vector(1, 2, 3)
    v2 = Vector(2, 3, 4)
    assert_equal v1.dot(v2), 20
  end

  def test_cross_product_of_two_vectors
    v1 = Vector(1, 2, 3)
    v2 = Vector(2, 3, 4)
    assert_equal v1.cross(v2), Vector(-1, 2, -1)
    assert_equal v2.cross(v1), Vector(1, -2, 1)
  end
end
