require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/ray'
require_relative '../lib/shape'
require_relative '../lib/sphere'

class TestShapes < Minitest::Test
  class TestShape < Shape
    attr_reader :object_space_ray, :object_space_point

    def intersect_shape(ray)
      @object_space_ray = ray
    end

    def normal_at_shape(point)
      @object_space_point = Vector(point.x, point.y, point.z)
    end
  end

  def test_sphere_default_transformation
    s = Shape.new
    assert_equal s.transform, Matrix.identity(4)
  end

  def test_changing_sphere_transformation
    s = Shape.new
    t = translation(2, 3, 4)
    s.transform = t
    assert_equal s.transform, t
  end

  def test_a_sphere_has_a_default_material
    s = Shape.new
    assert_kind_of Material, s.material
  end

  def test_a_sphere_can_be_assigned_a_material
    s = Shape.new
    m = Material.new(ambient: 1)
    s.material = m
    assert_equal s.material.ambient, m.ambient
  end

  def test_intersecting_a_scaled_shape_with_a_ray
    r = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    s = TestShape.new
    s.transform = scaling(2, 2, 2)
    s.intersect(r)
    assert_equal s.object_space_ray.origin, Point(0, 0, -2.5)
    assert_equal s.object_space_ray.direction, Vector(0, 0, 0.5)
  end

  def test_intersecting_a_translated_shape_with_a_ray
    r = Ray(Point(0, 0, -5), Vector(0, 0, 1))
    s = TestShape.new
    s.transform = translation(5, 0, 0)
    s.intersect(r)
    assert_equal s.object_space_ray.origin, Point(-5, 0, -5)
    assert_equal s.object_space_ray.direction, Vector(0, 0, 1)
  end

  def test_computing_normal_on_a_translated_shape
    s = TestShape.new
    s.transform = translation(0, 1, 0)
    normal = s.normal_at(Point(0, 1.70711, -0.70711))
    assert_equal normal, Vector(0, 0.70711, -0.70711)
  end

  def test_computing_normal_on_a_scaled_shape
    s = TestShape.new
    s.transform = scaling(1, 0.5, 1)
    normal = s.normal_at(Point(0, Math.sqrt(2) / 2.0, -Math.sqrt(2) / 2.0))
    assert_equal normal, Vector(0, 0.97014, -0.24254)
  end
end
