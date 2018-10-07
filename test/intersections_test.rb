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

  def test_hit_when_all_intersections_have_positive_t
    s = Sphere()
    i1 = Intersection(1, s)
    i2 = Intersection(2, s)
    xs = Intersections(i1, i2)
    assert_equal xs.hit, i1
  end

  def test_hit_when_some_intersections_have_negative_t
    s = Sphere()
    i1 = Intersection(-1, s)
    i2 = Intersection(1, s)
    xs = Intersections(i1, i2)
    assert_equal xs.hit, i2
  end

  def test_hit_when_all_intersections_have_negative_t
    s = Sphere()
    i1 = Intersection(-2, s)
    i2 = Intersection(-1, s)
    xs = Intersections(i1, i2)
    assert_nil xs.hit
  end

  def test_the_hit_is_the_lowest_non_negative_intersection
    s = Sphere()
    i1 = Intersection(5, s)
    i2 = Intersection(7, s)
    i3 = Intersection(-3, s)
    i4 = Intersection(2, s)
    xs = Intersections(i1, i2, i3, i4)
    assert_equal xs.hit, i4
  end

  def test_precomputing_the_state_of_an_intersection
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    shape = Sphere()
    hit = Intersection(4, shape)
    hit.prepare_hit(ray)
    assert_equal hit.point, Point(0, 0, -1)
    assert_equal hit.eye_vector, Vector(0, 0, -1)
    assert_equal hit.normal_vector, Vector(0, 0, -1)
  end

  def test_an_intersection_occurs_on_the_outside
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    shape = Sphere()
    hit = Intersection(4, shape)
    hit.prepare_hit(ray)
    assert !hit.inside
  end

  def test_an_intersection_occurs_on_the_inside
    ray = Ray(Point(0, 0, 0), Vector(0, 0, 1))
    shape = Sphere()
    hit = Intersection(1, shape)
    hit.prepare_hit(ray)
    assert_equal hit.point, Point(0, 0, 1)
    assert_equal hit.eye_vector, Vector(0, 0, -1)
    assert_equal hit.normal_vector, Vector(0, 0, -1)
    assert hit.inside
  end

  def test_the_point_is_an_offset
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    shape = Sphere()
    hit = Intersection(4, shape)
    hit.prepare_hit(ray)
    assert hit.point.z > -1.1
    assert hit.point.z < -1
  end
end
