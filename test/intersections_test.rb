require 'minitest/autorun'
require_relative '../lib/intersection'

class TestIntersections < Minitest::Test
  def test_intersection_encapsulates_t_object
    s = Sphere()
    i = Intersection(3.5, s)
    assert_equal i.t, 3.5
    assert_equal i.object, s
  end

  def test_aggregating_intersections
    s = Sphere()
    i1 = Intersection(1, s)
    i2 = Intersection(2, s)
    xs = Intersections(i1, i2)
    assert_equal xs.count, 2
    assert_equal xs[0].t, 1
    assert_equal xs[1].t, 2
  end
end
