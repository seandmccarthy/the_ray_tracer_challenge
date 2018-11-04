class Tuple
  EPSILON = 5
  attr_accessor :x, :y, :z, :w

  def initialize(x, y, z, w)
    @x = Float x
    @y = Float y
    @z = Float z
    @w = Integer w
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
    Tuple.new((x / denominator).round(EPSILON),
              (y / denominator).round(EPSILON),
              (z / denominator).round(EPSILON),
              (w / denominator).round(EPSILON))
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
    super(red.round(EPSILON), green.round(EPSILON), blue.round(EPSILON), 0)
  end
  alias red x
  alias green y
  alias blue z

  WHITE = Colour.new(255, 255, 255)
  BLACK = Colour.new(0, 0, 0)

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
