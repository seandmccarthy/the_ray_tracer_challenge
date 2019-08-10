class BlendedPattern < Pattern
  attr_reader :a, :b

  def initialize(a:, b:, transform: Matrix.identity(4))
    super(transform: transform)
    @a = a
    @b = b
  end

  def pattern_at(point)
    a_colour = a.pattern_at(point)
    b_colour = b.pattern_at(point)
    Colour((a_colour.red + b_colour.red) / 2.0,
           (a_colour.green + b_colour.green) / 2.0,
           (a_colour.blue + b_colour.blue) / 2.0)
  end
end

def BlendedPattern(*args)
  BlendedPattern.new(*args)
end
