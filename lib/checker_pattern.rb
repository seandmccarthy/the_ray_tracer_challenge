class CheckerPattern < Pattern
  attr_reader :a, :b

  def initialize(a:, b:, transform: Matrix.identity(4))
    super(transform: transform)
    @a = a
    @b = b
  end

  def pattern_at(point)
    return a if (point.x.floor + point.y.floor + point.z.floor) % 2 == 0
    b
  end
end

def CheckerPattern(**args)
  CheckerPattern.new(**args)
end
