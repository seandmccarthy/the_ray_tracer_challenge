class GradientPattern < Pattern
  attr_reader :a, :b

  def initialize(a:, b:, transform: Matrix.identity(4))
    super(transform: transform)
    @a = a
    @b = b
  end

  def pattern_at(point)
    distance = b - a
    fraction = point.x - point.x.floor
    tuple = a + (distance * fraction)
    Colour(tuple.x, tuple.y, tuple.z)
  end
end

def GradientPattern(*args)
  GradientPattern.new(*args)
end
