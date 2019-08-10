class RingPattern < Pattern
  attr_reader :a, :b

  def initialize(a:, b:, transform: Matrix.identity(4))
    super(transform: transform)
    @a = a
    @b = b
  end

  def pattern_at(point)
    return a if (Math.sqrt((point.x ** 2) + (point.z ** 2)).floor % 2 == 0)
    b
  end
end

def RingPattern(*args)
  RingPattern.new(*args)
end
