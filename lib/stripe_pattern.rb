class StripePattern < Pattern
  attr_reader :a, :b

  def initialize(a:, b:, transform: Matrix.identity(4))
    super(transform: transform)
    @a = a
    @b = b
  end

  def pattern_at(point)
    return a if point.x.floor.even?
    b
  end
end

def StripePattern(*args)
  StripePattern.new(*args)
end
