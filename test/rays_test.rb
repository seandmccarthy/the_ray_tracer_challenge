require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/transformation'

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

  def test_translating_a_ray
    r = Ray(Point(1, 2, 3), Vector(0, 1, 0))
    m = translation(3, 4, 5)
    r2 = r.transform(m)
    assert_equal r2.origin, Point(4, 6, 8)
    assert_equal r2.direction, Vector(0, 1, 0)
  end

  def test_scaling_a_ray
    r = Ray(Point(1, 2, 3), Vector(0, 1, 0))
    m = scaling(2, 3, 4)
    r2 = r.transform(m)
    assert_equal r2.origin, Point(2, 6, 12)
    assert_equal r2.direction, Vector(0, 3, 0)
  end
end
