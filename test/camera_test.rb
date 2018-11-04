require 'minitest/autorun'
require_relative '../lib/camera'
require_relative '../lib/tuple'
require_relative '../lib/transformation'

class TestCamera < Minitest::Test
  def test_constructing_a_camera
    h_size = 160
    v_size = 120
    field_of_view = Math::PI / 2
    c = Camera(h_size, v_size, field_of_view)
    assert_equal c.hsize, 160
    assert_equal c.vsize, 120
    assert_equal c.field_of_view, Math::PI / 2
    assert_equal c.transform, Matrix.identity
  end

  def test_the_pixel_size_for_a_horizontal_canvas
    c = Camera(200, 125, Math::PI / 2)
    assert_in_delta c.pixel_size, 0.01
  end

  def test_the_pixel_size_for_a_vertical_canvas
    c = Camera(125, 200, Math::PI / 2)
    assert_in_delta c.pixel_size, 0.01
  end

  def test_construct_a_ray_through_the_centre_of_the_canvas
    c = Camera(201, 101, Math::PI / 2)
    r = c.ray_for_pixel(100, 50)
    assert_equal r.origin, Point(0, 0, 0)
    assert_equal r.direction, Vector(0, 0, -1)
  end

  def test_contruct_a_ray_through_a_corner_of_the_canvas
    c = Camera(201, 101, Math::PI / 2)
    r = c.ray_for_pixel(0, 0)
    assert_equal r.origin, Point(0, 0, 0)
    assert_equal r.direction, Vector(0.66519, 0.33259, -0.66851)
  end

  def test_construct_a_ray_when_the_camera_is_transformed
    c = Camera(201, 101, Math::PI / 2)
    c.transform = rotation_y(Math::PI / 4) * translation(0, -2, 5)
    r = c.ray_for_pixel(100, 50)
    assert_equal r.origin, Point(0, 2, -5)
    assert_equal r.direction, Vector(Math.sqrt(2) / 2, 0, -Math.sqrt(2) / 2)
  end

  def test_rendering_a_world_with_a_camera
    w = default_world
    c = Camera(11, 11, Math::PI / 2)
    from = Point(0, 0, -5)
    to = Point(0, 0, 0)
    up = Vector(0, 1, 0)
    c.transform = Matrix.view_transform(from: from, to: to, up: up)
    image = c.render(w)
    IO.write('render_test.ppm', image.to_ppm.string)

    assert_equal image.pixel_at(5, 5), Colour(0.3986, 0.49824, 0.29895)
  end
end
