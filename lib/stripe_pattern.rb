class StripePattern
  attr_reader :a, :b
  attr_accessor :transform

  def initialize(a:, b:, transform: Matrix.identity(4))
    @a = a
    @b = b
    @transform = transform
  end

  def stripe_at(point)
    return a if point.x.floor.even?
    b
  end

  def stripe_at_object(object, world_point)
    object_space_point = object.transform.inverse * world_point
    pattern_point = transform.inverse * object_space_point
    stripe_at(pattern_point)
  end
end

def StripePattern(*args)
  StripePattern.new(*args)
end
