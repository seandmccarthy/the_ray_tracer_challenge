require 'minitest/autorun'
require_relative '../lib/tuple'
require_relative '../lib/point_light'

class LightsTest < Minitest::Test
  def test_a_point_light_has_a_position_and_intensity
    intensity = Colour(1, 1, 1)
    position = Point(0, 0, 0)
    light = PointLight(position, intensity)
    assert_equal light.position, position
    assert_equal light.intensity, intensity
  end
end
