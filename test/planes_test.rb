require 'minitest/autorun'
require_relative '../lib/shape'
require_relative '../lib/plane'

class TestPlanes < Minitest::Test
  def test_the_normal_of_a_plane_is_constant_everywhere
    p = Plane()
    n1 = p.normal_at_shape(Point(0, 0, 0))
    n2 = p.normal_at_shape(Point(10, 0, -10))
    n3 = p.normal_at_shape(Point(-5, 0, 150))
    assert_equal n1, Vector(0, 1, 0)
    assert_equal n2, Vector(0, 1, 0)
    assert_equal n3, Vector(0, 1, 0)
  end

  def test_intersect_with_a_ray_parallel_to_the_plane
    p = Plane()
    r = Ray(Point(0, 10, 0), Vector(0, 0, 1))
    xs = p.intersect(r)
    assert_equal xs.count, 0
  end

  # Coplanar: on the same plane
  def test_intersect_with_a_coplanar_ray
    p = Plane()
    r = Ray(Point(0, 0, 0), Vector(0, 0, 1))
    xs = p.intersect(r)
    assert_equal xs.count, 0
  end

  def test_a_ray_intersects_a_plane_from_above
    p = Plane()
    r = Ray(Point(0, 1, 0), Vector(0, -1, 0))
    xs = p.intersect(r)
    assert_equal xs.count, 1
    assert_equal xs[0].t, 1
    assert_equal xs[0].object, p
  end

  def test_a_ray_intersects_a_plane_from_below
    p = Plane()
    r = Ray(Point(0, -1, 0), Vector(0, 1, 0))
    xs = p.intersect(r)
    assert_equal xs.count, 1
    assert_equal xs[0].t, 1
    assert_equal xs[0].object, p
  end
end
