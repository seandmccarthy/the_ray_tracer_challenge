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
end
