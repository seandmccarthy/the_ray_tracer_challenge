class Tuple
  EPSILON = 5
  attr_accessor :x, :y, :z, :w

  def initialize(x, y, z, w)
    @x = Float x
    @y = Float y
    @z = Float z
    @w = Float w
  end

  def ==(other)
    x.round(EPSILON) == other.x.round(EPSILON) &&
      y.round(EPSILON) == other.y.round(EPSILON) &&
      z.round(EPSILON) == other.z.round(EPSILON) &&
      w == other.w
  end

  def +(other)
    Tuple.new(x + other.x, y + other.y, z + other.z, w + other.w)
  end

  def -(other)
    Tuple.new(x - other.x, y - other.y, z - other.z, w - other.w)
  end
end

class Point < Tuple
  def initialize(x, y, z)
    super(x, y, z, 1)
  end
end

class Vector < Tuple
  def initialize(x, y, z)
    super(x, y, z, 0)
  end
end
