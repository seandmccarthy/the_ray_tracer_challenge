class Sphere
  attr_accessor :transform

  def initialize
    @transform = Matrix.identity(4)
  end

  def intersect(ray)
    a, b, c = coefficents(ray.transform(@transform.inverse))
    build_intersections quadratic_roots(a, b, c)
  end

  private

  def coefficents(ray)
    sphere_to_ray = ray.origin - Point(0, 0, 0)
    a = ray.direction.dot(ray.direction)
    b = 2 * ray.direction.dot(sphere_to_ray)
    c = sphere_to_ray.dot(sphere_to_ray) - 1
    [a, b, c]
  end

  def quadratic_roots(a, b, c)
    discriminant = b * b - 4 * a * c
    return [] if discriminant < 0
    [
      (-b - Math.sqrt(discriminant)) / (2 * a),
      (-b + Math.sqrt(discriminant)) / (2 * a)
    ]
  end

  def build_intersections(t_values)
    Intersections(*t_values.sort.map { |t| Intersection(t, self) })
  end
end

def Sphere
  Sphere.new
end
