require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/transformation'

class TestTransformations < Minitest::Test
  def test_multiplying_by_translation_matrix
    transform = translation(5, -3, 2)
    p = Point(-3, 4, 5)
    assert_equal transform * p, Point(2, 1, 7)
  end

  def test_mutiplying_by_inverse_of_translation_matrix
    transform = translation(5, -3, 2)
    inv = transform.inverse
    p = Point(-3, 4, 5)
    assert_equal inv * p, Point(-8, 7, 3)
  end

  def test_translation_does_not_change_vectors
    transform = translation(5, -3, 2)
    v = Vector(-3, 4, 5)
    assert_equal transform * v, v
  end

  def test_scaling_a_point
    transform = scaling(2, 3, 4)
    p = Point(-4, 6, 8)
    assert_equal transform * p, Point(-8, 18, 32)
  end

  def test_scaling_a_vector
    transform = scaling(2, 3, 4)
    v = Vector(-4, 6, 8)
    assert_equal transform * v, Vector(-8, 18, 32)
  end

  def test_multiply_by_inverse_of_scaling_matrix
    transform = scaling(2, 3, 4)
    inv = transform.inverse
    v = Vector(-4, 6, 8)
    v_inverse = inv * v
    assert_equal Vector(v_inverse.x.round(0),
                        v_inverse.y.round(0),
                        v_inverse.z.round(0)),
                 Vector(-2, 2, 2)
  end

  def test_reflection_by_scaling_with_negative
    transform = scaling(-1, 1, 1)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(-2, 3, 4)
  end

  def test_rotating_a_point_around_the_x_axis
    p = Point(0, 1, 0)
    half_quarter = rotation_x(Math::PI / 4)
    full_quarter = rotation_x(Math::PI / 2)
    assert_equal half_quarter * p,
                 Point(0, Math.sqrt(2) / 2.0, Math.sqrt(2) / 2.0)
    assert_equal full_quarter * p, Point(0, 0, 1)
  end

  def test_inverse_of_x_rotation
    p = Point(0, 1, 0)
    half_quarter = rotation_x(Math::PI / 4)
    inv = half_quarter.inverse
    assert_equal inv * p,
                 Point(0, Math.sqrt(2) / 2.0, -Math.sqrt(2) / 2.0)
  end

  def test_rotating_a_point_around_the_y_axis
    p = Point(0, 0, 1)
    half_quarter = rotation_y(Math::PI / 4)
    full_quarter = rotation_y(Math::PI / 2)
    assert_equal half_quarter * p,
                 Point(Math.sqrt(2) / 2.0, 0, Math.sqrt(2) / 2.0)
    assert_equal full_quarter * p, Point(1, 0, 0)
  end

  def test_rotating_a_point_around_the_z_axis
    p = Point(0, 1, 0)
    half_quarter = rotation_z(Math::PI / 4)
    full_quarter = rotation_z(Math::PI / 2)
    assert_equal half_quarter * p,
                 Point(-Math.sqrt(2) / 2.0, Math.sqrt(2) / 2.0, 0)
    assert_equal full_quarter * p, Point(-1, 0, 0)
  end

  def test_shearing_moves_x_in_proportion_to_y
    transform = shearing(1, 0, 0, 0, 0, 0)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(5, 3, 4)
  end

  def test_shearing_moves_x_in_proportion_to_z
    transform = shearing(0, 1, 0, 0, 0, 0)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(6, 3, 4)
  end

  def test_shearing_moves_y_in_proportion_to_x
    transform = shearing(0, 0, 1, 0, 0, 0)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(2, 5, 4)
  end

  def test_shearing_moves_y_in_proportion_to_z
    transform = shearing(0, 0, 0, 1, 0, 0)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(2, 7, 4)
  end

  def test_shearing_moves_z_in_proportion_to_x
    transform = shearing(0, 0, 0, 0, 1, 0)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(2, 3, 6)
  end

  def test_shearing_moves_z_in_proportion_to_y
    transform = shearing(0, 0, 0, 0, 0, 1)
    p = Point(2, 3, 4)
    assert_equal transform * p, Point(2, 3, 7)
  end

  def test_individual_transformations_applied_in_sequence
    p = Point(1, 0, 1)
    a = rotation_x(Math::PI / 2.0)
    b = scaling(5, 5, 5)
    c = translation(10, 5, 7)
    p2 = a * p
    assert_equal a * p, Point(1, -1, 0)
    p3 = b * p2
    assert_equal p3, Point(5, -5, 0)
    p4 = c * p3
    assert_equal p4, Point(15, 0, 7)
  end

  def test_chained_transformations_must_be_applied_in_reverse_order
    p = Point(1, 0, 1)
    a = rotation_x(Math::PI / 2.0)
    b = scaling(5, 5, 5)
    c = translation(10, 5, 7)
    t = c * b * a
    assert_equal t * p, Point(15, 0, 7)
  end

  def test_view_transformation_matrix_for_the_default_orientation
    from = Point(0, 0, 0)
    to = Point(0, 0, -1)
    up = Vector(0, 1, 0)
    t = view_transform(from: from, to: to, up: up)
    assert_equal t, Matrix.identity
  end

  def test_view_transformation_matrix_looking_in_positive_z_direction
    from = Point(0, 0, 0)
    to = Point(0, 0, 1)
    up = Vector(0, 1, 0)
    t = view_transform(from: from, to: to, up: up)
    assert_equal t, scaling(-1, 1, -1)
  end

  def test_view_transformation_moves_the_world
    from = Point(0, 0, 8)
    to = Point(0, 0, 0)
    up = Vector(0, 1, 0)
    t = view_transform(from: from, to: to, up: up)
    assert_equal t, translation(0, 0, -8)
  end

  def test_arbitrary_view_transformation
    from = Point(1, 3, 2)
    to = Point(4, -2, 8)
    up = Vector(1, 1, 0)
    t = view_transform(from: from, to: to, up: up)
    expected = Matrix(
      [-0.50709, 0.50709, 0.67612, -2.36643],
      [0.76772, 0.60609, 0.12122, -2.82843],
      [-0.35857, 0.59761, -0.71714, 0.00000],
      [0.00000, 0.00000, 0.00000, 1.00000]
    )
    assert expected.approx_equal(t)
  end
end
