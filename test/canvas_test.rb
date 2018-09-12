require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/canvas'

class TestCanvas < Minitest::Test
  def test_creating_a_canvas
    c = Canvas(10, 20)
    assert_equal c.width, 10
    assert_equal c.height, 20
    c.pixels.each do |pixel|
      assert_equal pixel, Colour(0, 0, 0)
    end
  end

  def test_write_pixel
    c = Canvas(10, 20)
    red = Colour(1, 0, 0)
    c.write_pixel(2, 3, red)
    assert_equal c.pixel_at(2, 3), red
  end

  def test_to_ppm_header
    c = Canvas(5, 3)
    ppm = c.to_ppm
    assert_equal ppm.readlines[0..2].join, <<~END_OF_PPM
      P3
      5 3
      255
    END_OF_PPM
  end

  def test_to_ppm_data
    c = Canvas(5, 3)
    c1 = Colour(1.5, 0, 0)
    c2 = Colour(0, 0.5, 0)
    c3 = Colour(-0.5, 0, 1)
    c.write_pixel(0, 0, c1)
    c.write_pixel(2, 1, c2)
    c.write_pixel(4, 2, c3)
    ppm = c.to_ppm
    data = ppm.readlines
    assert_equal data[3..-1].join, <<~END_OF_PPM
      255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
    END_OF_PPM
  end

  def test_to_ppm_line_length
    c = Canvas(10, 2)
    colour = Colour(1, 0.8, 0.6)
    c.height.times do |y|
      c.width.times do |x|
        c.write_pixel(x, y, colour)
      end
    end
    ppm = c.to_ppm
    assert_equal ppm.readlines.join, <<~END_OF_PPM
      P3
      10 2
      255
      255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
      153 255 204 153 255 204 153 255 204 153 255 204 153
      255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
      153 255 204 153 255 204 153 255 204 153 255 204 153
    END_OF_PPM
  end
end
