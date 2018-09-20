require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/transformation'

class TestTransformations < Minitest::Test
  def test_multiplying_by_translation_matrix
    transform = Translation(5, -3, 2)
    p = Point(-3, 4, 5)
    assert_equal transform * p, Point(2, 1, 7)
  end

  def test_mutiplying_by_inverse_of_translation_matrix
    transform = Translation(5, -3, 2)
    inv = transform.inverse
    p = Point(-3, 4, 5)
    assert_equal inv * p, Point(-8, 7, 3)
  end

  def test_translation_does_not_change_vectors
    transform = Translation(5, -3, 2)
    v = Vector(-3, 4, 5)
    assert_equal transform * v, v
  end

  def test_scaling_a_point
    transform = Scaling(2, 3, 4)
    p = Point(-4, 6, 8)
    assert_equal transform * p, Point(-8, 18, 32)
  end

  def test_scaling_a_vector
    transform = Scaling(2, 3, 4)
    v = Vector(-4, 6, 8)
    assert_equal transform * v, Vector(-8, 18, 32)
  end

  def test_multiply_by_inverse_of_scaling_matrix
    transform = Scaling(2, 3, 4)
    inv = transform.inverse
    v = Vector(-4, 6, 8)
    v_inverse = inv * v
    assert_equal Vector(v_inverse.x.round(0),
                        v_inverse.y.round(0),
                        v_inverse.z.round(0)),
                 Vector(-2, 2, 2)
  end

  def test_reflection_by_scaling_with_negative
    transform = Scaling(-1, 1, 1)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(-2, 3, 4)
  end
end
