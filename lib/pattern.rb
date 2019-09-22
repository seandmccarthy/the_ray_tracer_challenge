class Pattern
  attr_accessor :transform

  def initialize(transform: Matrix.identity(4))
    @transform = transform
  end

  def pattern_at_shape(shape:, point:)
    object_space_point = shape.transform.inverse * point
    pattern_point = transform.inverse * object_space_point
    pattern_at(pattern_point)
  end
end

class TestPattern < Pattern
  def pattern_at(point)
    Colour(point.x, point.y, point.z)
  end
end
