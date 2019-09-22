class Tuple
  DECIMAL_PLACES = 5
  EPSILON = 0.0001
  attr_accessor :x, :y, :z, :w

  def initialize(x, y, z, w)
    @x = Float x
    @y = Float y
    @z = Float z
    @w = Integer w
  end

  def ==(other)
    x.round(DECIMAL_PLACES) == other.x.round(DECIMAL_PLACES) &&
      y.round(DECIMAL_PLACES) == other.y.round(DECIMAL_PLACES) &&
      z.round(DECIMAL_PLACES) == other.z.round(DECIMAL_PLACES) &&
      w == other.w
  end

  def +(other)
    Tuple.new(x + other.x, y + other.y, z + other.z, w + other.w)
  end

  def -(other)
    Tuple.new(x - other.x, y - other.y, z - other.z, w - other.w)
  end

  def -@
    Tuple.new(-x, -y, -z, -w)
  end

  def *(other)
    scalar = Float(other)
    Tuple.new(x * scalar, y * scalar, z * scalar, w * scalar)
  end

  def /(other)
    scalar = Float(other)
    Tuple.new(x / scalar, y / scalar, z / scalar, w / scalar)
  end

  def magnitude
    Math.sqrt(x**2 + y**2 + z**2 + w**2)
  end

  def normalise
    denominator = magnitude
    Tuple.new((x / denominator).round(DECIMAL_PLACES),
              (y / denominator).round(DECIMAL_PLACES),
              (z / denominator).round(DECIMAL_PLACES),
              (w / denominator).round(DECIMAL_PLACES))
  end

  def dot(other)
    (x * other.x) +
      (y * other.y) +
      (z * other.z) +
      (w * other.w)
  end

  def cross(other)
    Vector(y * other.z - z * other.y,
           z * other.x - x * other.z,
           x * other.y - y * other.x)
  end

  def reflect(normal)
    self - normal * 2 * dot(normal)
  end

  def to_s
    "x: #{x}, y: #{y}, z: #{z}, w: #{w}"
  end
end

def Tuple(*args)
  Tuple.new(*args)
end

def Point(*args)
  Point.new(*args)
end

class Point < Tuple
  def initialize(x, y, z)
    super(x, y, z, 1)
  end
end

def Vector(*args)
  Vector.new(*args)
end

class Vector < Tuple
  def initialize(x, y, z)
    super(x, y, z, 0)
  end
end

def Colour(*args)
  Colour.new(*args)
end

class Colour < Tuple
  def initialize(red, green, blue)
    super(
      red.round(DECIMAL_PLACES),
      green.round(DECIMAL_PLACES),
      blue.round(DECIMAL_PLACES),
      0
    )
  end
  alias red x
  alias green y
  alias blue z

  WHITE = Colour.new(1, 1, 1)
  BLACK = Colour.new(0, 0, 0)
  RED   = Colour.new(1, 0, 0)
  GREEN = Colour.new(0, 1, 0)
  BLUE  = Colour.new(0, 0, 1)
  PURPLE  = Colour.new(0.5, 0, 0.5)

  def hadamard_product(other)
    Colour(red * other.red, green * other.green, blue * other.blue)
  end

  def *(other)
    if other.is_a? Colour
      hadamard_product(other)
    else
      super
    end
  end
end
