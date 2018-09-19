require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/translation'

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
end
