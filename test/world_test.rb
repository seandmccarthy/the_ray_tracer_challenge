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

  def test_precomputing_the_state_of_an_intersection
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    shape = Sphere()
    i = Intersection(4, shape)
    comps = i.prepare_computations(ray)
    assert_equal comps.t, i.t
    assert_equal comps.object, i.object
    assert_equal comps.point, Point(0, 0, -1)
    assert_equal comps.eye_vector, Vector(0, 0, -1)
    assert_equal comps.normal_vector, Vector(0, 0, -1)
  end

  def test_the_hit_when_an_intersection_is_on_the_outside
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    shape = Sphere()
    i = Intersection(4, shape)
    comps = i.prepare_computations(ray)
    assert !comps.inside
  end

  def test_the_hit_when_an_intersection_is_on_the_inside
    ray = Ray(Point(0, 0, 0), Vector(0, 0, 1))
    shape = Sphere()
    i = Intersection(1, shape)
    comps = i.prepare_computations(ray)
    assert_equal comps.point, Point(0, 0, 1)
    assert_equal comps.eye_vector, Vector(0, 0, -1)
    assert comps.inside
    assert_equal comps.normal_vector, Vector(0, 0, -1)
  end

  def test_shading_an_intersection
    world = default_world
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    shape = world.objects.first
    hit = Intersection(4, shape)
    comps = hit.prepare_computations(ray)
    c = world.shade_hit(comps)
    assert_equal c, Colour(0.38066, 0.47582, 0.28549)
  end

  def test_shading_an_intersection_from_the_inside
    world = default_world
    world.light_source = PointLight(Point(0, 0.25, 0), Colour(1, 1, 1))
    ray = Ray(Point(0, 0, 0), Vector(0, 0, 1))
    shape = world.objects[1]
    hit = Intersection(0.5, shape)
    comps = hit.prepare_computations(ray)
    c = world.shade_hit(comps)
    assert_equal c, Colour(0.90495, 0.90495, 0.90495)
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

  def test_the_colour_with_an_intersection_behind_the_ray
    world = default_world
    outer = world.objects.first
    outer.material.ambient = 1
    inner = world.objects.last
    inner.material.ambient = 1
    ray = Ray(Point(0, 0, 0.75), Vector(0, 0, -1))
    assert_equal world.colour_at(ray), inner.material.colour
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
    comps = hit.prepare_computations(ray)
    c = w.shade_hit(comps)
    assert_equal c, Colour(0.1, 0.1, 0.1)
  end

  def test_the_reflected_colour_for_a_nonreflective_material
    world = default_world
    ray = Ray(Point(0, 0, 0), Vector(0, 0, 1))
    shape = world.objects.last
    shape.material.ambient = 1
    i = Intersection(1, shape)
    comps = i.prepare_computations(ray)
    assert_equal world.reflected_colour(comps), Colour(0, 0, 0)
  end

  def test_the_reflected_colour_for_a_reflective_material
    shape = Plane(material: Material(reflective: 0.5), transform: translation(0, -1, 0))
    world = default_world
    world.objects << shape
    ray = Ray(Point(0, 0, -3), Vector(0, -Math.sqrt(2) / 2, Math.sqrt(2) / 2))
    i = Intersection(Math.sqrt(2), shape)
    comps = i.prepare_computations(ray)
    assert_equal world.reflected_colour(comps), Colour(0.19035, 0.23793, 0.14276)
  end

  def test_shade_hit_with_a_reflective_material
    shape = Plane(material: Material(reflective: 0.5), transform: translation(0, -1, 0))
    world = default_world
    world.objects << shape
    ray = Ray(Point(0, 0, -3), Vector(0, -Math.sqrt(2) / 2, Math.sqrt(2) / 2))
    i = Intersection(Math.sqrt(2), shape)
    comps = i.prepare_computations(ray)
    assert_equal world.shade_hit(comps), Colour(0.87677, 0.92435, 0.82918)
  end

  def test_colour_at_with_mutually_reflective_surfaces
    lower = Plane(material: Material(reflective: 1), transform: translation(0, -1, 0))
    upper = Plane(material: Material(reflective: 1), transform: translation(0, 1, 0))
    light = PointLight(Point(0, 0, 0), Colour(1, 1, 1))
    world = World(objects: [lower, upper], light_source: light)
    ray = Ray(Point(0, 0, 0), Vector(0, 1, 0))
    assert !world.colour_at(ray).nil?
  end

  def test_the_reflected_colour_at_maximim_recursion_depth
    world = default_world
    shape = Plane(material: Material(reflective: 0.5), transform: translation(0, -1, 0))
    world.objects << shape
    ray = Ray(Point(0, 0, -3), Vector(0, -Math.sqrt(2) / 2, Math.sqrt(2) / 2))
    i = Intersection(Math.sqrt(2), shape)
    comps = i.prepare_computations(ray)
    colour = world.reflected_colour(comps, 0)
    assert_equal colour, Colour::BLACK
  end

  def test_the_refracted_colour_with_an_opaque_surface
    world = default_world
    shape = world.objects.first
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    xs = Intersections(Intersection(4, shape), Intersection(6, shape))
    comps = xs[0].prepare_computations(ray, xs)
    c = world.refracted_colour(comps, 5)
    assert_equal Colour::BLACK, c
  end

  def test_the_refracted_colour_at_the_maximum_recursive_depth
    world = default_world
    shape = world.objects.first
    shape.material.transparency = 1.0
    shape.material.refractive_index = 1.5
    ray = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    xs = Intersections(Intersection(4, shape), Intersection(6, shape))
    comps = xs[0].prepare_computations(ray, xs)
    c = world.refracted_colour(comps, 0)
    assert_equal Colour::BLACK, c
  end

  def test_the_refracted_colour_under_total_internal_reflection
    world = default_world
    shape = world.objects.first
    shape.material.transparency = 1.0
    shape.material.refractive_index = 1.5
    ray = Ray(Point(0, 0, Math.sqrt(2) / 2.0), Vector(0, 1, 0))
    xs = Intersections(
      Intersection(-Math.sqrt(2) / 2.0, shape),
      Intersection(Math.sqrt(2) / 2.0, shape)
    )
    comps = xs[1].prepare_computations(ray, xs)
    c = world.refracted_colour(comps, 5)
    assert_equal Colour::BLACK, c
  end

  def test_the_refracted_colour_with_a_refracted_ray
    world = default_world
    a = world.objects[0]
    a.material.ambient = 1.0
    a.material.pattern = TestPattern.new
    b = world.objects[1]
    b.material.transparency = 1.0
    b.material.refractive_index = 1.5
    ray = Ray(Point(0, 0, 0.1), Vector(0, 1, 0))
    xs = Intersections(
      Intersection(-0.9899, a),
      Intersection(-0.4899, b),
      Intersection(0.4899, b),
      Intersection(0.9899, a)
    )
    comps = xs[2].prepare_computations(ray, xs)
    c = world.refracted_colour(comps, 5)
    assert_equal Colour(0, 0.99878, 0.04724), c
  end

  def test_shade_hit_with_a_reflective_transparent_material
    world = default_world
    ray = Ray(Point(0, 0, -3), Vector(0, -Math.sqrt(2) / 2, Math.sqrt(2) / 2))
    floor =
      Plane(
        transform: translation(0, -1, 0),
        material: Material(reflective: 0.5, transparency: 0.5, refractive_index: 1.5)
      )
    world.objects << floor
    ball = Sphere(transform: translation(0, -3.5, -0.5), material: Material(colour: Colour::RED, ambient: 0.5))
    world.objects << ball
    xs = Intersections(Intersection(Math.sqrt(2), floor))
    comps =xs[0].prepare_computations(ray, xs)
    colour = world.shade_hit(comps, 5)
    assert_equal Colour(0.93391, 0.69643, 0.69243), colour
  end
end
