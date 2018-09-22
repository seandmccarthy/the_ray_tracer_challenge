require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/sphere'

class TestRays < Minitest::Test
  def test_creating_and_querying_a_ray
    origin = Point(1, 2, 3)
    direction = Vector(4, 5, 6)
    r = Ray(origin, direction)
    assert_equal r.origin, origin
    assert_equal r.direction, direction
  end

  def test_computing_a_point_from_a_distance
    r = Ray(Point(2, 3, 4), Vector(1, 0, 0))
    assert_equal r.position(0), Point(2, 3, 4)
    assert_equal r.position(1), Point(3, 3, 4)
    assert_equal r.position(-1), Point(1, 3, 4)
    assert_equal r.position(2.5), Point(4.5, 3, 4)
  end

  def test_a_ray_intersects_a_sphere_at_two_points
    r = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0], 4
    assert_equal xs[1], 6
  end

  def test_a_ray_intersects_a_sphere_at_a_tangent
    r = Ray(Point(0, 1, -5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0], 5
    assert_equal xs[1], 5
  end

  def test_a_ray_misses_a_sphere
    r = Ray(Point(0, 2, -5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 0
  end

  def test_a_ray_originates_inside_a_sphere
    r = Ray(Point(0, 0, 0), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0], -1
    assert_equal xs[1], 1
  end

  def test_a_sphere_is_behind_a_ray
    r = Ray(Point(0, 0, 5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0], -6
    assert_equal xs[1], -4
  end
end
