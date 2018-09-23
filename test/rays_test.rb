require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/ray'

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
end
