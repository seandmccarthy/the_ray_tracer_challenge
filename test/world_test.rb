require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/material'
require_relative '../lib/sphere'
require_relative '../lib/point_light'
require_relative '../lib/matrix'
require_relative '../lib/world'

class TestWorld < Minitest::Test
  def test_creating_a_world
    w = World()
    assert_empty w.objects
    assert_nil w.light_source
  end

  def test_default_world
    light = PointLight(Point(-10, 10, -10), Colour(1, 1, 1))
    w = default_world
    assert_equal w.light_source, light
    assert_equal w.objects.size, 2
  end

  def test_intersect_a_world_with_a_ray
    world = default_world
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    xs = world.intersect(ray)
    assert_equal xs.count, 4
    assert_equal xs[0].t, 4
    assert_equal xs[1].t, 4.5
    assert_equal xs[2].t, 5.5
    assert_equal xs[3].t, 6
  end

  def test_shading_an_intersection
    world = default_world
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    shape = world.objects.first
    hit = Intersection(4, shape)
    hit.prepare_hit(ray)
    c = world.shade_hit(hit)
    assert_equal c, Colour(0.38066, 0.47582, 0.28549)
  end

  def test_shading_an_intersection_from_the_inside
    world = default_world
    world.light_source = PointLight(Point(0, 0.25, 0), Colour(1, 1, 1))
    ray = Ray(Point(0, 0, 0), Vector(0, 0, 1))
    shape = world.objects[1]
    hit = Intersection(0.5, shape)
    hit.prepare_hit(ray)
    c = world.shade_hit(hit)
    assert_equal c, Colour(0.90499, 0.90499, 0.90499)
  end

  def test_the_colour_when_a_ray_misses
    world = default_world
    ray = Ray(Point(0, 0, -5), Vector(0, 1, 0))
    c = world.colour_at(ray)
    assert_equal c, Colour(0, 0, 0)
  end

  def test_the_colour_when_a_ray_hits
    world = default_world
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    c = world.colour_at(ray)
    assert_equal c, Colour(0.38066, 0.47582, 0.28549)
  end

  def test_there_is_no_shadow_when_nothing_is_collinear_with_point_and_light
    world = default_world
    p = Point(0, 10, 0)
    assert !world.shadowed?(p)
  end

  def test_shadow_when_an_object_is_between_the_point_and_the_light
    world = default_world
    p = Point(10, -10, 10)
    assert world.shadowed?(p)
  end

  def test_there_is_no_shadow_when_an_object_is_behind_the_light
    world = default_world
    p = Point(-20, 20, -20)
    assert !world.shadowed?(p)
  end

  def test_there_is_no_shadow_when_an_object_is_behind_the_point
    world = default_world
    p = Point(-2, 2, -2)
    assert !world.shadowed?(p)
  end

  def test_shade_hit_is_given_an_intersection_in_shadow
    s1 = Sphere()
    s2 = Sphere().tap { |s| s.transform = translation(0, 0, 10) }
    light = PointLight(Point(0, 0, -10), Colour(1, 1, 1))
    w = World(objects: [s1, s2], light_source: light)
    ray = Ray(Point(0, 0, 5), Vector(0, 0, 1))
    hit = Intersection(4, s2)
    hit.prepare_hit(ray)
    c = w.shade_hit(hit)
    assert_equal c, Colour(0.1, 0.1, 0.1)
  end
end
