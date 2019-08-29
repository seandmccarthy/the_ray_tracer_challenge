require 'minitest/autorun'
require_relative '../lib/material'
require_relative '../lib/tuple'
require_relative '../lib/point_light'
require_relative '../lib/pattern'
require_relative '../lib/stripe_pattern'

class TestMaterials < Minitest::Test
  def test_default_material
    m = Material()
    assert_equal m.colour, Colour(1, 1, 1)
    assert_equal m.ambient, 0.1
    assert_equal m.diffuse, 0.9
    assert_equal m.specular, 0.9
    assert_equal m.shininess, 200
  end

  def test_lighting_with_eye_between_light_and_surface
    m = Material()
    position = Point(0, 0, 0)
    eye_vector = Vector(0, 0, -1)
    normal_vector = Vector(0, 0, -1)
    light = PointLight(Point(0, 0, -10), Colour(1, 1, 1))
    result = m.lighting(object: Sphere(), light: light, point: position,
                        eye_vector: eye_vector, normal_vector: normal_vector)
    assert_equal result, Colour(1.9, 1.9, 1.9)
  end

  def test_lighting_with_eye_at_45_degrees_between_light_and_surface
    m = Material()
    position = Point(0, 0, 0)
    eye_vector = Vector(0, Math.sqrt(2) / 2, Math.sqrt(2) / 2)
    normal_vector = Vector(0, 0, -1)
    light = PointLight(Point(0, 0, -10), Colour(1, 1, 1))
    result = m.lighting(object: Sphere(), light: light, point: position,
                        eye_vector: eye_vector, normal_vector: normal_vector)
    assert_equal result, Colour(1.0, 1.0, 1.0)
  end

  def test_lighting_with_eye_opposite_and_light_offset_45_degrees
    m = Material()
    position = Point(0, 0, 0)
    eye_vector = Vector(0, 0, -1)
    normal_vector = Vector(0, 0, -1)
    light = PointLight(Point(0, 10, -10), Colour(1, 1, 1))
    result = m.lighting(object: Sphere(), light: light, point: position,
                        eye_vector: eye_vector, normal_vector: normal_vector)
    assert_equal result, Colour(0.7364, 0.7364, 0.7364)
  end

  def test_lighting_with_eye_in_the_path_of_the_reflection_vector
    m = Material()
    position = Point(0, 0, 0)
    eye_vector = Vector(0, -Math.sqrt(2) / 2, -Math.sqrt(2) / 2)
    normal_vector = Vector(0, 0, -1)
    light = PointLight(Point(0, 10, -10), Colour(1, 1, 1))
    result = m.lighting(object: Sphere(), light: light, point: position,
                        eye_vector: eye_vector, normal_vector: normal_vector)
    assert_equal result, Colour(1.6364, 1.6364, 1.6364)
  end

  def test_lighting_with_the_light_behind_the_surface
    m = Material()
    position = Point(0, 0, 0)
    eye_vector = Vector(0, 0, -1)
    normal_vector = Vector(0, 0, -1)
    light = PointLight(Point(0, 0, 10), Colour(1, 1, 1))
    result = m.lighting(object: Sphere(), light: light, point: position,
                        eye_vector: eye_vector, normal_vector: normal_vector)
    assert_equal result, Colour(0.1, 0.1, 0.1)
  end

  def test_lighting_with_the_surface_in_shadow
    m = Material()
    position = Point(0, 0, 0)
    eye_vector = Vector(0, 0, -1)
    normal_vector = Vector(0, 0, -1)
    light = PointLight(Point(0, 0, -10), Colour(1, 1, 1))
    in_shadow = true
    result = m.lighting(object: Sphere(), light: light, point: position,
                        eye_vector: eye_vector, normal_vector: normal_vector,
                        in_shadow: in_shadow)
    assert_equal result, Colour(0.1, 0.1, 0.1)
  end

  def test_lighting_with_a_pattern_applied
    m = Material(ambient: 1, diffuse: 0, specular: 0)
    m.pattern = StripePattern(a: Colour::WHITE, b: Colour::BLACK)
    eye_vector = Vector(0, 0, -1)
    normal_vector = Vector(0, 0, -1)
    light = PointLight(Point(0, 0, -10), Colour(1, 1, 1))
    c1 = m.lighting(object: Sphere(), light: light, point: Point(0.9, 0, 0),
                    eye_vector: eye_vector, normal_vector: normal_vector,
                    in_shadow: false)
    c2 = m.lighting(object: Sphere(), light: light, point: Point(1.1, 0, 0),
                    eye_vector: eye_vector, normal_vector: normal_vector,
                    in_shadow: false)
    assert_equal c1, Colour::WHITE
    assert_equal c2, Colour::BLACK
  end

  def test_reflectivity_for_the_default_material
    m = Material()
    assert_equal m.reflective, 0.0
  end
end
