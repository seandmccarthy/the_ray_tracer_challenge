require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/sphere'

class TestSpheres < Minitest::Test
  def test_a_ray_intersects_a_sphere_at_two_points
    r = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0].t, 4
    assert_equal xs[1].t, 6
  end

  def test_a_ray_intersects_a_sphere_at_a_tangent
    r = Ray(Point(0, 1, -5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0].t, 5
    assert_equal xs[1].t, 5
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
    assert_equal xs[0].t, -1
    assert_equal xs[1].t, 1
  end

  def test_a_sphere_is_behind_a_ray
    r = Ray(Point(0, 0, 5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0].t, -6
    assert_equal xs[1].t, -4
  end

  def test_intersect_sets_the_object_on_the_intersection
    r = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    s = Sphere()
    xs = s.intersect(r)
    assert_equal xs.count, 2
    assert_equal xs[0].object, s
    assert_equal xs[1].object, s
  end
end
