class Ray
  attr_reader :origin, :direction

  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end

  def position(t)
    origin + direction * t
  end

  def transform(matrix)
    Ray(matrix * @origin, matrix * @direction)
  end
end

def Ray(origin, direction)
  Ray.new(origin, direction)
end
